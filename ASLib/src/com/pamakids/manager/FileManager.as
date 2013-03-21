package com.pamakids.manager
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	/**
	 * 文件管理
	 * @author mani
	 */
	public class FileManager
	{

		/**
		 * 读取文件
		 * @param path 路径
		 */
		public static function readFile(path:String):Object
		{
			var o:Object;

			try
			{
				var f:File=File.applicationStorageDirectory.resolvePath(path);
				trace(f.nativePath);
				if (!f.exists)
					return o;
				var fs:FileStream=new FileStream();
				fs.open(f, FileMode.READ);
				o=fs.readObject();
				fs.close();
			}
			catch (error:Error)
			{
			}

			return o;
		}

		public static function readFileByteArray(path:String):ByteArray
		{
			var o:ByteArray=new ByteArray();

			try
			{
				var f:File=File.applicationStorageDirectory.resolvePath(path);
				if (!f.exists)
					return o;
				var fs:FileStream=new FileStream();
				fs.open(f, FileMode.READ);
				fs.readBytes(o);
				fs.close();
			}
			catch (error:Error)
			{
			}

			return o;
		}

		/**
		 * 保存文件
		 * @param path 文件路径，必须是dir/subdir/filename.extendtion的格式，切忌不能以/开头
		 * @param file 存储文件的数据
		 */
		public static function saveFile(path:String, file:Object):File
		{
			var directory:String=path.match(new RegExp('.*(?=/)'))[0];
			var arr:Array=path.split('/')
			var fileName:String=arr[arr.length - 1];
			var file1:File=File.applicationStorageDirectory.resolvePath(directory);
			if (!file1.exists)            // 如果不存在
				file1.createDirectory();    //创建指定的目录和任何所需的父目录。如果该目录已存在，则不执行任何操作
			var fs:FileStream=new FileStream();            //创建 FileStream 对象。使用 open() 或 openAsync() 方法打开文件。
			var file2:File=file1.resolvePath(fileName);
			try
			{
				fs.open(file2, FileMode.WRITE);
				if (file is ByteArray)
					fs.writeBytes(file as ByteArray)
				else if(file is String)
					fs.writeUTFBytes(file as String);
				else 
					fs.writeObject(file);
				fs.close();
			}
			catch (error:Error)
			{
			}
			return file2;
		}
	}
}


