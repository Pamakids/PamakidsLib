package com.pamakids.manager
{
	import com.pamakids.utils.Singleton;
	import com.pamakids.utils.URLUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	/**
	 * 资源管理器
	 * @author mani
	 */
	public class AssetsManager extends Singleton
	{

		public static function get instance():AssetsManager
		{
			return Singleton.getInstance(AssetsManager);
		}

		public function AssetsManager()
		{
			lm=LoadManager.instance;
		}

		private var bitmapDic:Dictionary=new Dictionary();

		private var imageTypes:Array=['.jpg', '.png'];
		private var lm:LoadManager;

		private var loadedCallbacks:Array=[];
		private var textureData:Dictionary=new Dictionary();

		private var themeDic:Dictionary=new Dictionary();
		private var tobeLoaded:Array=[];
		private var isHttpTheme:Boolean;

		public function addLoadedCallback(callback:Function):void
		{
			if (loadedCallbacks.indexOf(callback) == -1)
				loadedCallbacks.push(callback);
		}

		public function registAsset(name:String, bitmapOrClass:Object):void
		{
			bitmapDic[name]=bitmapOrClass is Class ? new bitmapOrClass : bitmapOrClass;
		}

		private var themeURL:String;

		public function loadTheme(url:String):void
		{
			themeLoaded=false;
			isHttpTheme=URLUtil.isHttp(url);
			themeURL=url;
			lm.loadText(url, loadedThemeInfoHandler);
		}

		private function loadedThemeInfoHandler(themeStr:String):void
		{
			var J:Object=getDefinitionByName('JSON') as Class;
			var theme:Object;
			if (J)
			{
				theme=J.parse(themeStr);
			}
			else
			{
				J=getDefinitionByName('com.adobe.serialization.json.JSON') as Class;
				theme=J.decode(themeStr);
			}
			parseCSS(theme);
			var dir:String=theme.dir;
			if (isHttpTheme)
				dir=URLUtil.getHttp(themeURL) + dir;
			var url:String;
			var savePath:String;
			for each (var asset:Object in theme.assets)
			{
				if (asset.type)
				{
					savePath=isHttpTheme ? dir + asset.name + asset.type : "";
					url=dir + asset.name + asset.type;
					tobeLoaded.push(asset.name + asset.type);
					lm.load(url, loadedHandler, savePath, [asset.name, asset.type], null, false, LoadManager.BITMAP);
				}
				else
				{
					savePath=isHttpTheme ? dir + asset.name : "";
					url=dir + asset.name + '.xml';
					tobeLoaded.push(asset.name + '.xml');
					lm.load(url, loadedHandler, savePath, [asset.name, '.xml'], null, false, URLLoaderDataFormat.TEXT);
					url=dir + asset.name + '.png';
					lm.load(url, loadedHandler, savePath, [asset.name, '.png'], null, false, LoadManager.BITMAP);
					tobeLoaded.push(asset.name + '.png');
				}
			}
		}

		private var css:Dictionary;

		private function parseCSS(theme:Object):void
		{
			if (theme.css)
			{
				css=new Dictionary();
				for (var p:String in theme.css)
				{
					css[p]=theme.css[p];
				}
			}
		}

		public function getStyle(name:String, cssID:String):Object
		{
			return css[cssID][name];
		}

		public function addAsset(name:String, bitmap:Bitmap):void
		{
			bitmapDic[name]=bitmap;
		}

		public function getAsset(name:String, type:String='image'):Bitmap
		{
			var asset:Bitmap;

			if (bitmapDic[name])
			{
				var b:Bitmap=bitmapDic[name];
				asset=new Bitmap(b.bitmapData);
			}
			else
			{
				var data:Object=textureData[name];
				if (!data)
					return null;
				var bitmap:Bitmap=bitmapDic[data.bitmapName];
				var bd:BitmapData=new BitmapData(data.width, data.height);
				bd.copyPixels(bitmap.bitmapData, new Rectangle(data.x, data.y, data.width, data.height), new Point());
				asset=new Bitmap(bd);
			}

			return asset;
		}

		public function removeLoadedCallback(callback:Function):void
		{
			var index:int=loadedCallbacks.indexOf(callback);
			if (index != -1)
				loadedCallbacks.splice(index, 1);
		}

		private function loadedHandler(data:Object, params:Array=null):void
		{
			var type:String=params[1];
			var name:String=params[0];

			if (imageTypes.indexOf(type) != -1)
			{
				bitmapDic[name]=data;
			}
			else if (type == '.xml')
			{
				var xml:XML=new XML(data);
				for (var i:int=0; i < xml.SubTexture.length(); i++)
				{
					var o:Object={};
					var nameString:String=xml.SubTexture[i].@name.toString();
					o.x=int(xml.SubTexture[i].@x);
					o.y=int(xml.SubTexture[i].@y);
					o.width=parseFloat(xml.SubTexture[i].@width);
					o.height=parseFloat(xml.SubTexture[i].@height);
					o.bitmapName=name;
					if (nameString.indexOf('/') != -1)
						nameString=nameString.substr(nameString.lastIndexOf('/') + 1);
					o.name=nameString;
					textureData[o.name]=o;
				}
			}

			tobeLoaded.splice(tobeLoaded.indexOf(name + type), 1);
			if (tobeLoaded.length == 0)
			{
				if (!themeLoaded)
				{
					themeLoaded=true;
					for each (var f:Function in loadedCallbacks)
					{
						f();
					}
				}
			}
		}

		public var themeLoaded:Boolean;
	}
}
