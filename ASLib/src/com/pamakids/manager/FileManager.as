package com.pamakids.manager
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;

	public class FileManager
	{

		public static function readFile(path:String, fromAppDirectory:Boolean=false, readString:Boolean=false, uncompress:Boolean=false):Object
		{
			if (Capabilities.playerType != 'Desktop')
				return null;

			var o:Object;

			try
			{
				var f:File=fromAppDirectory ? File.applicationDirectory.resolvePath(path) : File.applicationStorageDirectory.resolvePath(path);
				if (!f.exists)
					return o;
				var fs:FileStream=new FileStream();
				fs.open(f, FileMode.READ);
				if (!uncompress)
				{
					o=readString ? fs.readUTF() : fs.readObject();
				}
				else
				{
					var b:ByteArray=new ByteArray();
					fs.readBytes(b);
					b.uncompress();
					o=b.readObject();
				}
				fs.close();
			}
			catch (error:Error)
			{
			}

			return o;
		}

		public static function readFileByteArray(path:String):ByteArray
		{
			if (Capabilities.playerType != 'Desktop')
				return null;

			var o:ByteArray;

			try
			{
				var f:File=File.applicationStorageDirectory.resolvePath(path);
				if (!f.exists)
					return o;
				trace("Read File ByteArray:" + f.nativePath);
				var fs:FileStream=new FileStream();
				fs.open(f, FileMode.READ);
				o=new ByteArray()
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
		 * @param path 文件路径，必须是dir/subdir/filename.extendtion的格式
		 * @param file 存储文件的数据
		 */
		public static function saveFile(path:String, fileObject:Object, compress:Boolean=false):File
		{
			if (Capabilities.playerType != 'Desktop')
				return null;
			if (path.charAt(0) == '/')
				path=path.substr(1);
			createDirectory(path);
			var fs:FileStream=new FileStream();
			var file:File=File.applicationStorageDirectory.resolvePath(path);
			try
			{
				fs.open(file, FileMode.WRITE);
				if (compress)
				{
					var b:ByteArray=new ByteArray();
					b.writeObject(fileObject);
					b.compress();
					fileObject=b;
				}
				if (fileObject is ByteArray)
					fs.writeBytes(fileObject as ByteArray)
				else if (fileObject is String)
					fs.writeUTFBytes(fileObject as String);
				else
					fs.writeObject(fileObject);
				fs.close();
			}
			catch (error:Error)
			{
				trace('save file error', error);
			}
			return file;
		}

		private static function createDirectory(path:String):void
		{
			if (Capabilities.playerType != 'Desktop')
				return;
			var directory:String=path.match(new RegExp('.*(?=/)'))[0]; //a
			var file:File=File.applicationStorageDirectory.resolvePath(directory);
			if (!file.exists)
			{
				trace("FileCache - Directory not found, create it !");
				file.createDirectory();
			}
		}

		public static function copyTo(source:File, toPath:String, overrite:Boolean=true):void
		{
			if (Capabilities.playerType != 'Desktop')
				return;
			var toFile:File=new File(toPath);
			if (source.nativePath != toFile.nativePath)
			{
				try
				{
					source.copyTo(toFile, overrite);
				}
				catch (error:Error)
				{
					trace("Copy File Error:" + error.toString());
				}
			}
		}

		public static function deleteFile(path:String):void
		{
			if (Capabilities.playerType != 'Desktop')
				return;
			var f:File=new File(path);
			try
			{
				if (f.exists)
					f.deleteFileAsync();
			}
			catch (error:Error)
			{
				trace("Delete File Error:" + error.toString());
			}
		}

	}
}


