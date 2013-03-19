package com.pamakids.manager
{
	import com.pamakids.utils.Singleton;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.Dictionary;

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

		public function addLoadedCallback(callback:Function):void
		{
			loadedCallbacks.push(callback);
		}

		public function loadTheme(theme:Object, cache:Boolean=false):void
		{
			var dir:String=theme.dir;
			var url:String;
			var savePath:String;
			for each (var asset:Object in theme.assets)
			{
				if (asset.type)
				{
					savePath=cache ? dir + asset.name + asset.type : "";
					url=dir + asset.name + asset.type;
					tobeLoaded.push(asset.name + asset.type);
					lm.load(url, loadedHandler, savePath, [asset.name, asset.type], null, false, LoadManager.BITMAP);
				}
				else
				{
					savePath=cache ? dir + asset.name : "";
					url=dir + asset.name + '.xml';
					tobeLoaded.push(asset.name + '.xml');
					lm.load(url, loadedHandler, savePath, [asset.name, '.xml'], null, false, URLLoaderDataFormat.TEXT);
					url=dir + asset.name + '.png';
					lm.load(url, loadedHandler, savePath, [asset.name, '.png'], null, false, LoadManager.BITMAP);
					tobeLoaded.push(asset.name + '.png');
				}
			}
		}

		public function getAsset(name:String, type:String='image'):Bitmap
		{
			var asset:Bitmap;

			if (bitmapDic[name])
			{
				asset=bitmapDic[name];
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
					o.name=xml.SubTexture[i].@name.toString();
					o.x=int(xml.SubTexture[i].@x);
					o.y=int(xml.SubTexture[i].@y);
					o.width=parseFloat(xml.SubTexture[i].@width);
					o.height=parseFloat(xml.SubTexture[i].@height);
					o.bitmapName=name;
					textureData[o.name]=o;
				}
			}

			tobeLoaded.splice(tobeLoaded.indexOf(name + type), 1);
			if (tobeLoaded.length == 0)
			{
				for each (var f:Function in loadedCallbacks)
				{
					f();
				}
			}
		}
	}
}
