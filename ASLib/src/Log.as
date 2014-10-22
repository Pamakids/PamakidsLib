package
{
	import com.pamakids.utils.DateUtil;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class Log
	{
		public static const LEVEL_NOTSET:int=0;
		public static const LEVEL_DEBUG:int=10;
		public static const LEVEL_INFO:int=20;
		public static const LEVEL_WARN:int=30;
		public static const LEVEL_ERROR:int=40;
		public static var level:int=LEVEL_NOTSET;
		/**
		 * 本地日志路径，为空则不保存本地日志，需要设置为完整路径
		 */
		public static var logPath:String='';
		/**
		 * 是否是测试，测试状态会保存所有日志，默认非测试状态，仅保存当天日志
		 */
		public static var isTest:Boolean=false;

		private static function appendPlayLog(log:String):void
		{
			if (!log)
				return;
			var path:String=logPath;
			var file:File;
			var fs:FileStream=new FileStream();
			createDirectory(path);
			file=new File(logPath);
			try
			{
				if (!isTest && file.exists && file.creationDate.date != new Date().date)
					file.deleteFile();
				fs.open(file, FileMode.APPEND);
				fs.writeUTFBytes(log + '\n');
				fs.close();
			}
			catch (error:Error)
			{
				Log.Trace('save log error', error);
			}
		}

		private static function createDirectory(path:String):void
		{
			var arr:Array=path.match(new RegExp('.*(?=/)'));
			if (!arr || !arr.length)
				return;
			var directory:String=arr[0]; //a
			var file:Object=new File(directory);
			if (!file.exists)
			{
				Log.Trace('Create Log Dir');
				file.createDirectory();
			}
		}

		private static function log(level:String, ... args):void
		{
			try
			{
				var stackTrace:String=new Error().getStackTrace();
				if (!Boolean(stackTrace))
				{
					return;
				}
				var s:String=stackTrace.split("\n", 4)[3];
				var tmp:Array=s.split('[', 2);
				var info:String='';
				if (tmp && tmp.length == 2)
				{
					var funcName:String=tmp[0].split(' ').pop();
					var arr:Array=tmp[1].split(':');
					if (arr)
						s=arr.pop();
					var lineNo:String=s.split(']').shift();
					info=DateUtil.getDateString(0, 0, true) + ' ' + level + '[' + funcName + ':' + lineNo + '] ';
				}
				else
				{
					info=DateUtil.getDateString(0, 0, true) + ' ' + level + ' ' + s;
				}

				for each (var o:Object in args)
				{
					info+=o + ' ';
				}
				if (logPath)
					appendPlayLog(info);
			}
			catch (error:Error)
			{
				Log.Trace('Log Error:' + error);
			}
		}

		public static function debug(... args):void
		{
			if (level > LEVEL_DEBUG)
			{
				return;
			}
			log('[DEBUG]', args);
		}

		public static function info(... args):void
		{
			if (level > LEVEL_INFO)
			{
				return;
			}
			log('[INFO]', args);
		}

		public static function warn(... args):void
		{
			if (level > LEVEL_WARN)
			{
				return;
			}
			log('[WARN]', args);
		}

		public static function error(... args):void
		{
			if (level > LEVEL_ERROR)
			{
				return;
			}
			log('[ERROR]', args);
		}

		public static var Trace:Function=function(... args):void
		{
			for each (var o:Object in args)
			{
				trace(o);
			}
		};
	}
}
