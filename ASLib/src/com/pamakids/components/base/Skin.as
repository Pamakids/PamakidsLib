package com.pamakids.components.base
{
	import com.pamakids.manager.AssetsManager;

	import flash.display.Bitmap;

	public class Skin extends Container
	{

		private var am:AssetsManager;

		public function Skin(width:Number=0, height:Number=0, enableBackground:Boolean=false, enableMask:Boolean=false)
		{
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
		}
	}
}
