package com.pamakids.components.base
{
	import com.pamakids.filters.ColorFilter;
	import com.pamakids.manager.AssetsManager;
	import com.pamakids.utils.DPIUtil;

	import flash.display.Bitmap;
	import flash.utils.Dictionary;

	import avmplus.getQualifiedClassName;

	public class Skin extends Container
	{

		public static var css:Dictionary=new Dictionary();

		private var am:AssetsManager;
		public var styleName:String;

		/**
		 * 不同DPI的缩放比
		 */
		protected var dpiScale:Number;

		public function Skin(styleName:String, width:Number=0, height:Number=0, enableBackground:Boolean=false, enableMask:Boolean=false)
		{
			this.styleName=styleName;
			am=AssetsManager.instance;
			super(width, height, enableBackground, enableMask);
			dpiScale=DPIUtil.getDPIScale();
		}

		protected function getBitmap(name:String):Bitmap
		{
			return am.getAsset(name);
		}

		override protected function dispose():void
		{
			clearChildren();
			am.removeLoadedCallback(updateSkin);
			am=null;
		}

		private function clearChildren():void
		{
			while (numChildren)
			{
				var bitmap:Bitmap=removeChildAt(0) as Bitmap;
				if (bitmap)
					bitmap.bitmapData.dispose();
			}
		}

		override protected function init():void
		{
			am.addLoadedCallback(updateSkin);
		}

		protected function updateSkin():void
		{
			clearChildren();
		}

		protected function get themeLoaded():Boolean
		{
			return am.themeLoaded;
		}
	}
}
