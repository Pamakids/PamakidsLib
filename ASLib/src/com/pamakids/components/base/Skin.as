package com.pamakids.components.base
{
	import com.greensock.TweenLite;
	import com.pamakids.manager.AssetsManager;
	import com.pamakids.utils.DPIUtil;

	import flash.display.Bitmap;
	import flash.utils.Dictionary;

	public class Skin extends Container
	{

		public static var css:Dictionary=new Dictionary();

		private var am:AssetsManager;
		public var styleName:String;

		/**
		 * 不同DPI的缩放比
		 */
		protected var dpiScale:Number;
		protected var cssID:String;

		public function Skin(styleName:String, width:Number=0, height:Number=0, enableBackground:Boolean=false, enableMask:Boolean=false)
		{
			var s:String=this.toString();
			cssID=s.slice(s.indexOf(' ') + 1, s.length - 1);
			if (!styleName)
				styleName=cssID;
			this.styleName=styleName;
			am=AssetsManager.instance;
			super(width, height, enableBackground, enableMask);
			dpiScale=DPIUtil.getDPIScale();
		}

		protected function getStyle(name:String):Object
		{
			return am.getStyle(name, cssID);
		}

		protected function getColor(name:String='', id:String=''):uint
		{
			if (!id)
				id=cssID;
			if (!name)
				return uint(am.getStyle('color', id));
			var style:Object=am.getStyle(name, id);
			if (style.hasOwnProperty('color'))
				return uint(style['color']);
			return uint(style);
		}

		protected function getFontSize(name:String=''):uint
		{
			if (!name)
				return uint(am.getStyle('fontSize', cssID));
			var style:Object=am.getStyle(name, cssID);
			if (style.hasOwnProperty('fontSize'))
				return uint(style['fontSize']);
			return uint(style);
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
			TweenLite.killDelayedCallsTo(addCallback);
		}

		protected function disposeBitmap(bitmap:Object):void
		{
			if (bitmap as Bitmap)
			{
				bitmap.bitmapData.dispose();
				if (bitmap.parent)
					bitmap.parent.removeChild(bitmap);
			}
		}

		private function clearChildren():void
		{
			while (numChildren)
			{
				disposeBitmap(removeChildAt(0));
			}
		}

		override protected function init():void
		{
			TweenLite.delayedCall(1, addCallback);
			super.init();
		}

		private function addCallback():void
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
