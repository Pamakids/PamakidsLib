package com.pamakids.components.base
{
	import com.pamakids.layouts.ILayout;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class Container extends UIComponent
	{
		public function Container(width:Number=0, height:Number=0, enableBackground:Boolean=false, enableMask:Boolean=false)
		{
			this.enableBackground=enableBackground;
			this.enableMask=enableMask;
			super(width, height);
		}

		private var _backgroudAlpha:Number=0;
		private var _backgroundColor:uint=0;
		private var _enableBackground:Boolean;
		private var _enableMask:Boolean;
		private var _layout:ILayout;
		private var maskSprite:Sprite;

//		override public function set visible(value:Boolean):void
//		{
//			if (value)
//				trace(this);
//			super.visible=value;
//		}

		/**
		 * -1则不显示边框
		 * @return
		 *
		 */
		public function get lineColor():int
		{
			return _lineColor;
		}

		public function set lineColor(value:int):void
		{
			_lineColor=value;
			drawBackground();
			trace(value);
		}

		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}

		public function set backgroundColor(value:uint):void
		{
			_backgroundColor=value;
			drawBackground();
		}

		public function get backgroudAlpha():Number
		{
			return _backgroudAlpha;
		}

		public function set backgroudAlpha(value:Number):void
		{
			_backgroudAlpha=value;
			drawBackground();
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			if (layout)
				layout.addItem(child);
			else if (autoCenter)
				centerDisplayObject(child);
			return super.addChild(child);
		}

		override protected function autoSetSize(child:DisplayObject):void
		{
			if (!layout)
				super.autoSetSize(child);
		}

		public function get enableBackground():Boolean
		{
			return _enableBackground;
		}

		public function set enableBackground(value:Boolean):void
		{
			_enableBackground=value;
			drawBackground();
		}

		public function get enableMask():Boolean
		{
			return _enableMask;
		}

		public function set enableMask(value:Boolean):void
		{
			_enableMask=value;
			if (!value && maskSprite)
			{
				mask=null;
				super.removeChild(maskSprite);
				maskSprite=null;
			}
			drawMask();
		}

		public function get layout():ILayout
		{
			return _layout;
		}

		public function set layout(value:ILayout):void
		{
			_layout=value;
			if (value)
			{
				value.container=this;
				value.updateAll();
			}
		}

		override public function removeChild(child:DisplayObject):DisplayObject
		{
			if (layout)
				layout.removeItem(child);
			return super.removeChild(child);
		}

		override public function removeChildAt(index:int):DisplayObject
		{
			if (layout)
				layout.removeItem(getChildAt(index));
			return super.removeChildAt(index);
		}

		override protected function init():void
		{
			drawBackground();
			drawMask();
		}

		override protected function resize():void
		{
//			if (sizeChanged)
//			{
			drawBackground();
			drawMask();
//			}
			super.resize();
		}

		private var _lineColor:int=-1;

		protected function drawBackground():void
		{
			if (!width || !height || !enableBackground) //条件
				return;

			graphics.clear();
			graphics.beginFill(backgroundColor, backgroudAlpha);
			if (lineColor == -1)
				graphics.lineStyle(0, 0, 0);
			else
				graphics.lineStyle(1, lineColor);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}

		protected var maskTarget:Sprite;

		protected function drawMask():void
		{
			if (!enableMask || !width || !height)
				return;
			if (!maskSprite)
			{
				maskSprite=new Sprite();
				super.addChild(maskSprite);
			}
			maskSprite.graphics.clear();
			maskSprite.graphics.beginFill(0);
			maskSprite.graphics.drawRect(0, 0, width, height);
			maskSprite.graphics.endFill();
			if (!maskTarget)
				maskTarget=this;
			maskTarget.mask=maskSprite;
			trace(maskTarget);
		}
	}
}
