package com.pamakids.components.controls
{
	import com.greensock.TweenLite;
	import com.pamakids.components.base.Container;
	import com.pamakids.components.base.Skin;

	import flash.display.Bitmap;
	import flash.geom.Rectangle;

	/**
	 * 进度条
	 * @author mani
	 *
	 */
	public class ProgressBar extends Skin
	{
		private var track:ScaleBitmap;
		private var bar:ScaleBitmap;
		private var trackRect:Rectangle=new Rectangle(16, 8, 7, 6);
		private var barRect:Rectangle=new Rectangle(16, 8, 7, 6);

		public function get progress():Number
		{
			return _progress;
		}

		public function set progress(value:Number):void
		{
			_progress=value;
			if (!progressMask)
				return;
			TweenLite.to(progressMask, 0.3, {width: width * value});
			if (archor)
			{
				var tox:Number=width * value - archor.width / 2;
				value == 1 ? archor.x=tox : TweenLite.to(archor, 0.3, {x: tox});
			}
		}

		/**
		 * 设置缩放9宫格
		 * @param track
		 * @param bar
		 *
		 */
		public function setScale9Grids(track:Rectangle, bar:Rectangle):void
		{
			trackRect=track;
			barRect=bar;
		}

		public function ProgressBar(width:Number=0, height:Number=0, styleName:String='progressBar')
		{
			super(styleName, width, height);
		}

		override protected function updateSkin():void
		{
			if (!themeLoaded)
				return;
			super.updateSkin();

			track=new ScaleBitmap(getBitmap(styleName + 'Down').bitmapData);
			track.scale9Grid=trackRect;
			track.width=width;
			addChild(track);

			bar=new ScaleBitmap(getBitmap(styleName + 'Up').bitmapData);
			bar.mask=progressMask;
			bar.scale9Grid=barRect;
			bar.width=width;
			addChild(bar);

			height=track.height; //皮肤高度用track高度来定
			archor=getBitmap(styleName + 'Archor');
			archor.y=height / 2 - archor.height / 2;
			archor.x=width - archor.width / 2;
			addChild(archor);

			bg=getBitmap(styleName + 'BG');
			if (bg)
			{
				bg.x=width / 2 - bg.width / 2;
				bg.y=height / 2 - bg.height / 2;
				addChildAt(bg, 0);
			}
		}

		override protected function init():void
		{
			super.init();
			updateSkin();
			progressMask=new Container(width, height, true);
			addChild(progressMask);
			bar.mask=progressMask;
		}

		private var _progress:Number;

		private var progressMask:Container;
		private var archor:Bitmap;
		private var bg:Bitmap;

	}
}
