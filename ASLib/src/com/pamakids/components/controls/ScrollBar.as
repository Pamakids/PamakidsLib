package com.pamakids.components.controls
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
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
			restoring=true;
			_barHeight=value;
			resize();
		}

		public function get contentHeight():Number
		{
			return _contentHeight;
		}

		private var percent:Number;

		public function set contentHeight(value:Number):void
		{
			_contentHeight=value;
			percent=height / value;
			if (percent > 1)
			{
				barHeight=height;
				return;
			}
			var bh:Number;
			if (value > height)
				bh=percent * height;
			if (barHeight < MIN_BAR_HEIGHT)
				bh=MIN_BAR_HEIGHT;
			barHeight=bh;
		}

		private var storeBarHeight:Number=0;
		private var restoring:Boolean;
		private var extra:Number;

		public function scrollTo(position:Number):void
		{
			if (!storeBarHeight)
				storeBarHeight=barHeight;
			var to:Number=barHeight;
			if (position < 0)
			{
				to=storeBarHeight + position;
				to=to < MIN_BAR_HEIGHT ? MIN_BAR_HEIGHT : to;
				position=0;
			}
			else if (position > 0)
			{
				extra=position * percent + storeBarHeight - height;
				if (extra > 0)
				{
					to=storeBarHeight - extra;
					to=to < MIN_BAR_HEIGHT ? MIN_BAR_HEIGHT : to;
					position=height - to;
				}
				else
				{
					to=storeBarHeight;
					position=position * percent;
				}
			}
			barHeight=to;
			bar.y=position;
			TweenLite.to(this, 0.5, {alpha: 1});
		}

		private function hideBar():void
		{
			TweenLite.to(this, 1, {alpha: 0});
		}

		public function restore():void
		{
			if (!storeBarHeight)
				return;
			TweenLite.to(this, 0.5, {barHeight: storeBarHeight, ease: Cubic.easeOut, onComplete: hideBar});
			if (bar.y && extra > 0)
				TweenLite.to(bar, 0.5, {y: height - storeBarHeight, ease: Cubic.easeOut, onComplete: hideBar});
			storeBarHeight=0;
		}

		override protected function resize():void
		{
			if (!barHeight)
				return;

			bar.graphics.clear();
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
