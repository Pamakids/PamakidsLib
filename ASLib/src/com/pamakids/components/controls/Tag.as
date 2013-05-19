package com.pamakids.components.controls
{
	import com.pamakids.components.controls.Label;
	import com.pamakids.components.controls.ScaleBitmap;

	import flash.display.DisplayObject;

	/**
	 * 带有背景或前景的文字
	 * @author mani
	 */
	public class Tag extends Label
	{
		public function Tag(text:String="", width:Number=0, height:Number=0)
		{
			super(text, width, height);
		}

		public function get frontRight():Number
		{
			return _frontRight;
		}

		public function set frontRight(value:Number):void
		{
			_frontRight=value;
		}

		public function get frontTop():Number
		{
			return _frontTop;
		}

		public function set frontTop(value:Number):void
		{
			_frontTop=value;
		}

		public function get frontLeft():Number
		{
			return _frontLeft;
		}

		public function set frontLeft(value:Number):void
		{
			_frontLeft=value;
		}

		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}

		public function set paddingBottom(value:Number):void
		{
			_paddingBottom=value;
		}

		public function get paddingTop():Number
		{
			return _paddingTop;
		}

		public function set paddingTop(value:Number):void
		{
			_paddingTop=value;
		}

		public function get paddingRight():Number
		{
			return _paddingRight;
		}

		public function set paddingRight(value:Number):void
		{
			_paddingRight=value;
		}

		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}

		public function set paddingLeft(value:Number):void
		{
			_paddingLeft=value;
		}

		private var _background:ScaleBitmap;

		public function get frontMask():ScaleBitmap
		{
			return _frontMask;
		}

		protected function clearFrontMask():void
		{
			if (_frontMask)
			{
				_frontMask.bitmapData.dispose();
				removeChild(_frontMask);
			}
			_frontMask=null;
		}

		public function set frontMask(value:ScaleBitmap):void
		{
			_frontMask=value;
			if (value)
			{
				if (textField)
					addChild(value);
				sizeFrontMask();
			}
		}

		private var _paddingLeft:Number=0;
		private var _paddingRight:Number=0;
		private var _paddingTop:Number=0;
		private var _paddingBottom:Number=0;

		private var _frontLeft:Number=0;
		private var _frontTop:Number=0;
		private var _frontRight:Number=0;

		public function get background():ScaleBitmap
		{
			return _background;
		}

		protected function clearBackground():void
		{
			if (_background)
			{
				_background.bitmapData.dispose();
				removeChild(_background);
				_background=null;
			}
		}

		public function set background(value:ScaleBitmap):void
		{
			_background=value;
			if (value)
			{
				autoSetSize(value);
				addChildAt(value, 0);
				if (textField && value.height > height)
					centerDisplayObject(textField);
				sizeBackground();
			}
		}

		private function sizeBackground():void
		{
			if (background)
			{
				if (background.width < width || background.width > maxWidth)
					background.width=width;
				if (background.height < height)
				{
					background.height=height;
				}
				else if (forceAutoFill || background.getOriginalBitmapData().height > height)
				{
					height=background.height;
					centerDisplayObject(textField);
				}
			}
		}

		override protected function resize():void
		{
			super.resize();

			sizeBackground();
			sizeFrontMask();
		}

		private function sizeFrontMask():void
		{
			if (frontMask)
			{
				var tow:Number=width - frontLeft - frontRight;
				frontMask.x=frontLeft;
				frontMask.y=frontTop;
				frontMask.width=tow;
			}
		}

		override protected function init():void
		{
			super.init();
			if (frontMask)
				addChild(frontMask);
		}

		override protected function centerDisplayObject(child:DisplayObject):void
		{
			if (!child)
				return;
			if (child == textField)
			{
				textField.x=paddingLeft;
				if (height == paddingTop + paddingBottom + textField.height)
					textField.y=paddingTop;
				else if (height > textField.height)
					textField.y=height / 2 - textField.height / 2;
			}
		}

		override protected function measure():void
		{
			if (!textField)
				return;
			if (maxWidth)
			{
				if (width >= maxWidth)
				{
					textField.wordWrap=true;
					var tw:Number=maxWidth - paddingLeft - paddingRight;
					textField.width=tw;
					forceAutoFill=false;
					width=maxWidth;
					height=textField.height + paddingBottom + paddingTop;
					if (background)
					{
						background.width=width;
						background.height=textField.height + paddingTop + paddingBottom;
					}
				}
				else
				{
					forceAutoFill=true;
					textField.wordWrap=false;
					var tow:Number=textField.width + paddingLeft + paddingRight;
					if (tow > width)
						width=tow;
					height=textField.height + paddingTop + paddingBottom;
					if (background)
					{
						background.width=width;
						background.height=height;
					}
				}
				sizeFrontMask();
			}
		}

		override public function set width(value:Number):void
		{
			super.width=value;
			autoSetSize(textField);
		}

		override protected function autoSetSize(child:DisplayObject):void
		{
			if (!child)
				return;
			if (autoFill || forceAutoFill)
			{
				if (textField && child == textField)
					setSize(textField.width + paddingLeft + paddingRight, textField.height + paddingBottom + paddingTop);
				else
					setSize(child.width > width ? child.width : width, child.height > height ? child.height : height);
			}
			else if (textField)
			{
				textField.width=width - paddingLeft - paddingRight;
				height=textField.height + paddingTop + paddingBottom;
			}
		}

		private var _frontMask:ScaleBitmap;

	}
}

