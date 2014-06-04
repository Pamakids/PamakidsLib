package com.pamakids.manager
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	/**
	 * 文件管理器
	 * @author mani
	 */
	public class FileManager
	{
		public static var savedDir:String;

//		private static function get File():Class
//		{
//			try
//			{
//				return getDefinitionByName('flash.filesystem.File') as Class;
//			}
//			catch (error:Error)
//			{
//				trace(error);
//			}
//			return null;
//		}
//
//		private static function get FileMode():Class
//		{
//			return getDefinitionByName('flash.filesystem.FileMode') as Class;
//		}
//
//		private static function get FileStream():Class
//		{
//			return getDefinitionByName('flash.filesystem.FileStream') as Class;
//		}

		public static function readFile(path:String, fromAppDirectory:Boolean=false, readString:Boolean=false, uncompress:Boolean=false):Object
		{
			if (File)
			{
				var o:Object;

				try
				{
					var f:Object;
					if(savedDir)
						f = new File(savedDir+path);
					else
						f = fromAppDirectory ? File.applicationDirectory.resolvePath(path) : File.applicationStorageDirectory.resolvePath(path);
					if (!f.exists)
						return o;
					var fs:Object=new FileStream();
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
			return null;
		}

		public static function readFileByteArray(path:String):ByteArray
		{
			if (File)
			{
				var o:ByteArray;

				try
				{
					var f:Object=File.applicationStorageDirectory.resolvePath(path);
					if (!f.exists)
						return o;
					trace("Read File ByteArray:" + f.nativePath);
					var fs:Object=new FileStream();
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
			else
			{
				return null;
			}

		}

		/**
		 * 保存文件
		 * @param path 文件路径，必须是dir/subdir/filename.extendtion的格式
		 * @param file 存储文件的数据
		 */
		public static function saveFile(path:String, fileObject:Object, compress:Boolean=false):Object
		{
			if (File)
			{
				if (path.charAt(0) == '/')
					path=path.substr(1);
				var fs:Object=new FileStream();
				var file:Object;
				if(savedDir)
					file = new File(savedDir+path);
				else{
					createDirectory(path);
					file = File.applicationStorageDirectory.resolvePath(path);
				}
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
						fs.writeUTFBytes(fileObject as String); //!!!注意writeUTF
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
			return null;
		}

		private static function createDirectory(path:String):void
		{
			if (!File)
				return;
			var arr:Array=path.match(new RegExp('.*(?=/)'));
			if (!arr || !arr.length)
				return;
			var directory:String=arr[0]; //a
			var file:Object=File.applicationStorageDirectory.resolvePath(directory);
			if (!file.exists)
			{
				trace("FileCache - Directory not found, create it !");
				file.createDirectory();
			}
		}

		public static function copyTo(source:Object, toPath:String, overrite:Boolean=true):void
		{
			if (!File)
				return;
			var toFile:Object=new File(toPath);
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
			if (!File)
				return;
			var f:Object=new File(path);
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

		public static function deleteSavedFile(path:String, async:Boolean=false):void
		{
			if (!File)
				return;
			var f:Object=File.applicationStorageDirectory.resolvePath(path);
			try
			{
				if (f.exists)
					async ? f.deleteFileAsync() : f.deleteFile();
			}
			catch (error:Error)
			{
				trace("Delete File Error:" + error.toString());
			}
		}

	}
}


