package com.pamakids.utils
{

	public class URLUtil
	{
		public static function getRelativeURL(url:String):String
		{
			return isHttp(url) ? url.replace(new RegExp('(http|https)://.*?/'), '') : '';
		}

		public static function isHttp(url:String):Boolean
		{
			return url.indexOf('http') != -1;
		}

		public static function getCachePath(url:String):String
		{
			if (!isHttp(url))
				return '';
			var cachePath:String=getRelativeURL(url);
			if (cachePath.indexOf('/') == -1)
				cachePath='cache/' + cachePath;
			return cachePath;
		}

		public static function getExtenion(s:String):String
		{
			return s ? s.substr(s.lastIndexOf('.')) : '';
		}

		public static function getHttpPath(url:String):String
		{
			if (!isHttp(url))
				return '';
			else
				return url.match(new RegExp('(http|https)://.*/'))[0];
		}

		public static function getHttp(url:String):String
		{
			if (!isHttp(url))
				return '';
			else
				return url.match(new RegExp('(http|https)://.*?/'))[0];
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
