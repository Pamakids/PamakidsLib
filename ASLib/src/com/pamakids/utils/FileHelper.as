package com.pamakids.utils
{
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;

	public class FileHelper
	{

		public function FileHelper()
		{
		}

		/**
		 * 文件或文件夹浏览
		 * @param path
		 * @param mode
		 * 		* 1:browse
		 * 		* 2:browseForDirectory
		 * 		* 3:browseForOpen
		 * 		* 4:browseForOpenMultiple
		 * 		* 5:browseForSave
		 * @param callback 回调函数
		 */
		public static function browse(path:String, mode:int, callback:Function, title:String='', typeFilters:Array=null):void
		{
			FileHelper.callback=callback;

			var f:File=new File(path);
			switch (mode)
			{
				case 1:
					f.browse(typeFilters);
					break;
				case 2:
					f.browseForDirectory(title);
					break;
				case 3:
					f.browseForOpen(title, typeFilters);
					break;
				case 4:
					f.browseForOpenMultiple(title, typeFilters);
					break;
				case 5:
					f.browseForSave(title);
					break;
			}
			if (mode != 4)
				f.addEventListener(Event.SELECT, selectedHandler);
			else
				f.addEventListener(FileListEvent.SELECT_MULTIPLE, selectedHandler);
		}

		private static var callback:Function;

		protected static function selectedHandler(event:Event):void
		{
			var fe:FileListEvent=event as FileListEvent;
			var f:File=event.target as File;
			f.removeEventListener(Event.SELECT, selectedHandler);
			if (!fe)
				callback(f);
			else
				callback(fe.files);
			callback=null;
		}
	}
}
