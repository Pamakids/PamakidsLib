package com.pamakids.utils
{

	public class BrowserUtil
	{
		public function BrowserUtil()
		{
		}

		import flash.external.ExternalInterface;

		public static function getQuery():Object
		{
			var url:String=ExternalInterface.call("window.location.href.toString");
			var o:Object;
			if (url.indexOf('?') != -1)
			{
				var query:String=url.split('?')[1];
				if (query)
				{
					o={};
					var a1:Array=query.split('&');
					for each (var s:String in a1)
					{
						var a2:Array=s.split('=');
						if (a2.length == 2)
							o[a2[0]]=decodeURI(a2[1]);

					}
				}
			}
			return o;
		}

		public static function getHttpPath():String
		{
			var url:String=ExternalInterface.call("window.location.href.toString");
			return URLUtil.getHttpPath(url);
		}
	}
}
