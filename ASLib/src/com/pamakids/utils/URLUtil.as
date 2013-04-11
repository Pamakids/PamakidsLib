package com.pamakids.utils
{

	public class URLUtil
	{
		public static function getRelativeURL(url:String):String
		{
			return url.replace(new RegExp('(http|https)://.*?/'), '');
		}

		public static function isHttp(url:String):Boolean
		{
			return url.indexOf('http') != -1;
		}

		public static function getCachePath(url:String):String
		{
			var cachePath:String=getRelativeURL(url);
			if (cachePath.indexOf('/') == -1)
				cachePath='cache/' + cachePath;
			return cachePath;
		}

		public static function getUrlDir(url:String):String
		{
			if (!isHttp(url))
				return '';
			else
				return url.substring(0, url.lastIndexOf('/') + 1);
		}
	}
}
