package com.pamakids.components.controls
{

	public class Style
	{
		public static var embedFonts:Boolean=true;
		public static var fontName:String;
		/**
		 * 移动设备上，GPU模式下文字缓存成位图能提高性能
		 */
		public static var cacheAsBitmap:Boolean=true;
		public static const MAIN_COLOR:uint=0x806F5D;
		public static const PROMPT_COLOR:uint=0x666666;
		public static var fontLoaded:Boolean=true;
		private static var fontCallbackes:Array=[];

		public static function addFontCallback(f:Function):void
		{
			fontCallbackes.push(f);
		}

		public static function fontLoadedHandler():void
		{
			for each (var f:Function in fontCallbackes)
			{
				f();
			}
			fontCallbackes.length=0;
		}
	}
}
