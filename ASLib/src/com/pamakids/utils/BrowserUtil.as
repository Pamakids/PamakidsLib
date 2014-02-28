package com.pamakids.utils
{

	public class BrowserUtil
	{
		public function BrowserUtil()
		{
		}

		import flash.external.ExternalInterface;

		/**
		 * 获取url的查询数据
		 * @param url 如果为空则获取当前url
		 * @return {key:value}这样的对象
		 */
		public static function getQuery(url:String=''):Object
		{
			var urlString:String=url ? url : ExternalInterface.call("window.location.href.toString");
			var o:Object;
			if (urlString.indexOf('?') != -1)
			{
				var query:String=urlString.split('?')[1];
				if (query)
				{
					o={};
					var a1:Array=query.split('&');
					for each (var s:String in a1)
					{
						var a2:Array=s.split('=');
						if (a2.length == 2)
						{
							var value:String=a2[1];
							var uv:String;
							if (value && value.indexOf('http') == 0)
							{
								uv=unescape(value);
								o[a2[0]]=uv;
							}
							else
							{
								o[a2[0]]=decodeURI(value);
							}
						}

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
