package com.pamakids.utils
{

	public class URLUtil
	{
		public static function getRelativeURL(url:String):String
		{
			return url.replace(new RegExp('(http|https)://.*?/'), '');
		}

		public static function getCachePath(url:String):String
		{
			var cachePath:String=getRelativeURL(url);
			if (cachePath.indexOf('/') == -1)
				cachePath='cache/' + cachePath;
			return cachePath;
		}
	}
}
