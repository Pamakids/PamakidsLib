package com.pamakids.components.controls
{
	import com.pamakids.components.base.Container;
	import com.pamakids.manager.LoadManager;
	import com.pamakids.utils.BitmapDataUtil;
	import com.pamakids.utils.URLUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.ByteArray;

	/**
	 * 图片
	 * @author mani
	 */
	[Event(name="complete", type="flash.events.Event")]

	public class Image extends Container
	{

		public function Image(width:Number=0, height:Number=0, scaleMode:String=BitmapDataUtil.RESIZE_LETTERBOX, enableBakcgournd:Boolean=false)
		{
			this.scaleMode=scaleMode;
			super(width, height, enableBakcgournd);
		}

		private var _source:Object;

		public function get source():Object
		{
			return _source;
		}

		public var content:Bitmap;
		private var lm:LoadManager;
		private var scaleMode:String;
		public var smoothing:Boolean=true;
		public var showLoading:Boolean=true;
		private var loading:Label;

		public function set source(value:Object):void
		{
			if (!value)
			{
				dispose();
			}
			else if (value != _source)
			{
				lm=LoadManager.instance;
				
				if (value is String)
					lm.loadImage(value as String, loadedHandler, URLUtil.getCachePath(value as String), loadingHandler);
				else if (value is ByteArray)
					lm.loadContentFromByteArray(value as ByteArray, loadedHandler);
			}
			_source=value;
		}
		
		override protected function init():void
		{
			if(showLoading)
			{
				loading = new Label('00%');
				addChild(loading);
				centerDisplayObject(loading);
			}
		}
		
		private function loadingHandler(percent:Number):void
		{
			if(loading)
				loading.text = int(percent * 100) + '%';
		}
		
		override public function set autoCenter(value:Boolean):void
		{
			super.autoCenter=value;
			forceAutoFill=value;
		}

		protected function loadedHandler(bitmap:Bitmap):void
		{
			if(loading)
			{
				removeChild(loading);
				loading = null;
			}
			bitmap.smoothing=smoothing;
			if (forceAutoFill || autoFill)
			{
				content=bitmap;
			}
			else
			{
				var resizedBD:BitmapData=BitmapDataUtil.getResizedBitmapData(bitmap.bitmapData, width, height, scaleMode);
				content=new Bitmap(resizedBD);
			}
			content.smoothing=smoothing;
			addChild(content);
			if (!tobeDisposedBitmap)
				tobeDisposedBitmap=content;
			if (tobeDisposedBitmap != content)
				disposeBitmap();
			dispatchEvent(new Event('complete', true));
		}

		override protected function autoSetSize(child:DisplayObject):void
		{
			if (autoCenter)
				return;
			if (autoFill || forceAutoFill)
				setSize(child.width, child.height);
		}

		override protected function dispose():void
		{
			disposeBitmap();
			if (content && content.parent)
			{
				content.bitmapData.dispose();
				content.parent.removeChild(content);
				content=null;
			}
			tobeDisposedBitmap=null;
			lm=null;
		}

		private var tobeDisposedBitmap:Bitmap;

		private function disposeBitmap():void
		{
			if (tobeDisposedBitmap)
			{
				if (tobeDisposedBitmap.bitmapData)
					tobeDisposedBitmap.bitmapData.dispose();
				if (tobeDisposedBitmap.parent)
					tobeDisposedBitmap.parent.removeChild(tobeDisposedBitmap);
				if (content)
					tobeDisposedBitmap=content;
			}
		}

	}
}
