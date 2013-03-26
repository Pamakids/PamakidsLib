package com.pamakids.components.controls
{
	import com.pamakids.components.base.Skin;
	import com.pamakids.utils.ScaleBitmap;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class ScrollBar extends Skin
	{

		private var _contentHeight:Number;
		private var bar:Sprite;
		private var barBitmapData:BitmapData;
		private var _barHeight:Number;

		private const MIN_BAR_HEIGHT:int=40;

		public function ScrollBar(styleName:String, width:Number=0, height:Number=0)
		{
			bar=new Sprite();
			addChild(bar);

			super(styleName, width, height);
			updateSkin();
		}

		public function get barHeight():Number
		{
			return _barHeight;
		}

		public function set barHeight(value:Number):void
		{
			_barHeight=value;
			resize();
		}

		public function get contentHeight():Number
		{
			return _contentHeight;
		}

		public function set contentHeight(value:Number):void
		{
			_contentHeight=value;
			if (value > height)
				barHeight=(1 - height / value) * height;
			if (barHeight < MIN_BAR_HEIGHT)
				barHeight=MIN_BAR_HEIGHT;
		}

		public function scrollTo(position:Number):void
		{
			bar.y=position;
		}

		override protected function resize():void
		{
			if (!barHeight)
				return;

			ScaleBitmap.draw(barBitmapData, bar.graphics, width, barHeight, new Rectangle(5, 5, barBitmapData.width - 10, barBitmapData.height - 10), null, true);
		}

		override protected function updateSkin():void
		{
			barBitmapData=getBitmap(styleName).bitmapData;

			if (!width)
				width=barBitmapData.width;
			if (!height)
				height=barBitmapData.height;
		}

	}
}
