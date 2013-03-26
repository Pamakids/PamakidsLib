package com.pamakids.components.base
{
	import com.pamakids.filters.ColorFilter;
	import com.pamakids.manager.AssetsManager;

	import flash.display.Bitmap;
	import flash.utils.Dictionary;

	import avmplus.getQualifiedClassName;

	public class Skin extends Container
	{

		public static var css:Dictionary=new Dictionary();

		private var am:AssetsManager;
		protected var styleName:String;

		public function Skin(styleName:String, width:Number=0, height:Number=0, enableBackground:Boolean=false, enableMask:Boolean=false)
		{
			trace(getQualifiedClassName(this));
			this.styleName=styleName;
			am=AssetsManager.instance;
			bitmaps=[];
			super(width, height, enableBackground, enableMask);
		}

		private var bitmaps:Array;

		protected function getBitmap(name:String):Bitmap
		{
			var bitmap:Bitmap=am.getAsset(name);
			bitmaps.push(bitmap);
			return bitmap;
		}

		override protected function dispose():void
		{
			am=null;
			for each (var bitmap:Bitmap in bitmaps)
			{
				bitmap.bitmapData.dispose();
			}
			bitmaps.length=0;
			while (numChildren)
				removeChildAt(0);
			am.removeLoadedCallback(updateSkin);
		}

		override protected function init():void
		{
			am.addLoadedCallback(updateSkin);
		}

		protected function updateSkin():void
		{

		}

		private var _enable:Boolean=true;

		public function get enable():Boolean
		{
			return _enable;
		}

		public function set enable(value:Boolean):void
		{
			_enable=value;
			if (!value)
				filters=[ColorFilter.getDisableFilter()];
			else
				filters=[];
		}
	}
}
