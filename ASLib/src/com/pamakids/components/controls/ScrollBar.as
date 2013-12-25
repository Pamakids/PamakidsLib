package com.pamakids.components.controls
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.pamakids.components.base.Skin;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	/**
	 * 滚动条
	 * @author mani
	 */
	public class ScrollBar extends Skin
	{

		private var _contentHeight:Number;
		private var bar:ScaleBitmap;
		private var barBitmapData:BitmapData;
		private var _barHeight:Number;

		private const MIN_BAR_HEIGHT:int=40;

		public function ScrollBar(styleName:String, width:Number=0, height:Number=0)
		{
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

		private var recordedBarHeight:Number=0;
		private var restoring:Boolean;
		private var extra:Number;
		private var scaleRect:Rectangle;

		public function scrollTo(position:Number):void
		{
			if (!recordedBarHeight)
				recordedBarHeight=barHeight;
			var to:Number=barHeight;
			if (position < 0)
			{
				to=recordedBarHeight + position;
				to=to < MIN_BAR_HEIGHT ? MIN_BAR_HEIGHT : to;
				position=0;
			}
			else if (position > 0)
			{
				extra=position * percent + recordedBarHeight - height;
				if (extra > 0)
				{
					to=recordedBarHeight - extra;
					to=to < MIN_BAR_HEIGHT ? MIN_BAR_HEIGHT : to;
					position=height - to;
				}
				else
				{
					to=recordedBarHeight;
					position=position * percent;
				}
			}
			barHeight=to;
			bar.y=position;
			if (alpha == 0)
				alpha=1;
			TweenLite.killDelayedCallsTo(hideBar);
			TweenLite.delayedCall(0.5, hideBar);
		}

		private function hideBar():void
		{
			TweenLite.to(this, 1, {alpha: 0});
		}

		public function restore():void
		{
			if (!recordedBarHeight)
				return;
			TweenLite.to(this, 0.5, {barHeight: recordedBarHeight, ease: Cubic.easeOut, onComplete: hideBar});
			if (bar.y && extra > 0)
				TweenLite.to(bar, 0.5, {y: height - recordedBarHeight, ease: Cubic.easeOut, onComplete: hideBar});
			recordedBarHeight=0;
		}

		override protected function resize():void
		{
			if (!barHeight)
				return;
			bar.setSize(width, barHeight);
		}

		override protected function updateSkin():void
		{
			super.updateSkin();
			barBitmapData=getBitmap(styleName).bitmapData;
			if (!width)
				width=barBitmapData.width;
			if (!height)
				height=barBitmapData.height;
			bar=new ScaleBitmap(barBitmapData, 'auto', true);
			var btw:Number=barBitmapData.width;
			var bth:Number=barBitmapData.height;
			bar.scale9Grid=new Rectangle(btw / 2 - 1, bth / 2 - 1, 1, 1);
			addChild(bar);
		}

	}
}
