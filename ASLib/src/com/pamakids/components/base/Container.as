package com.pamakids.components.base
{
	import com.pamakids.events.ResizeEvent;
	import com.pamakids.layouts.ILayout;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;


	public class Container extends Sprite
	{
		public function Container(width:Number=0, height:Number=0, enableBackground:Boolean=false, enableMask:Boolean=false)
		{
			this.width=width;
			this.height=height;
			if (!width && !height)
				autoFill=true;
			this.enableBackground=enableBackground;
			this.enableMask=enableMask;
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}

		private var _layout:ILayout;

		public function get forceAutoFill():Boolean
		{
			return _forceAutoFill;
		}

		public function set forceAutoFill(value:Boolean):void
		{
			_forceAutoFill=value;
			if (!value)
			{
				trace('forceAutoFill:' + value);
				value=value;
			}
		}

		public function get layout():ILayout
		{
			return _layout;
		}

		public function set layout(value:ILayout):void
		{
			_layout=value;
			if (value)
				value.container=this;
		}

		public function get enableMask():Boolean
		{
			return _enableMask;
		}

		private var maskSprite:Sprite;

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

		private function drawMask():void
		{
			if (!enableMask || !width || !height)
				return;
			if (!maskSprite)
				maskSprite=new Sprite();
			maskSprite.graphics.clear();
			maskSprite.graphics.beginFill(0);
			maskSprite.graphics.drawRect(0, 0, width, height);
			maskSprite.graphics.endFill();
			super.addChild(maskSprite);
			mask=maskSprite;
		}

		protected function onStage(event:Event):void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			drawBackground();
			drawMask();
			init();
		}

		protected function init():void
		{
		}

		protected function onRemoved(event:Event):void
		{
			if (autoDispose)
			{
				removeEventListener(Event.ADDED_TO_STAGE, onStage);
				removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
				dispose();
			}
		}

		protected function dispose():void
		{
		}

		public var autoDispose:Boolean=true;

		private var _width:Number;
		private var _height:Number;

		/**
		 * 根据子项最大宽高设置宽高
		 */
		public var autoFill:Boolean;

		private var _centerFill:Boolean;

		private var _enableBackground:Boolean;
		private var _enableMask:Boolean;

		public function get enableBackground():Boolean
		{
			return _enableBackground;
		}

		public function set enableBackground(value:Boolean):void
		{
			_enableBackground=value;
			drawBackground();
		}

		public var backgroudAlpha:Number=0;
		public var backgroundColor:uint=0;

		private function drawBackground():void
		{
			if (!width || !height || !enableBackground) //条件
				return;

			graphics.clear();
			graphics.beginFill(backgroundColor, backgroudAlpha);
			graphics.lineStyle(0, 0, 0);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}

		/**
		 * 将子项定位到容器中央
		 */
		public function get centerFill():Boolean
		{
			return _centerFill;
		}

		/**
		 * @private
		 */
		public function set centerFill(value:Boolean):void
		{
			_centerFill=value;
			centerChildren();
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			if (layout)
				layout.addItem(child);
			if (centerFill)
				centerDisplayObject(child);
			autoSetSize(child);
			return super.addChild(child);
		}

		protected function autoSetSize(child:DisplayObject):void
		{
			if (autoFill || forceAutoFill)
			{
				setSize(child.width > width ? child.width : width, child.height > height ? child.height : height);
			}
		}

		override public function removeChild(child:DisplayObject):DisplayObject
		{
			if (layout)
				layout.removeItem(child);
			return super.removeChild(child);
		}

		protected function centerDisplayObject(child:DisplayObject):void
		{
			child.x=width / 2 - child.width / 2;
			child.y=height / 2 - child.height / 2;
		}

		private function centerChildren():void
		{
			if (centerFill)
			{
				for (var i:int; i < numChildren; i++)
				{
					centerDisplayObject(getChildAt(i));
				}
			}
		}

		override public function set width(value:Number):void
		{
			_width=value;
			resize();
		}

		private var _forceAutoFill:Boolean;

		protected function resize():void
		{
			if (width || height)
			{
				autoFill=forceAutoFill;
				centerChildren();
				drawBackground();
				drawMask();
				dispatchEvent(new ResizeEvent(width, height));
			}
		}

		public function setSize(width:Number, height:Number):void
		{
			_width=width;
			_height=height;
			resize();
		}

		override public function get height():Number
		{
			return _height;
		}

		override public function set height(value:Number):void
		{
			_height=value;
			resize();
		}

		override public function get width():Number
		{
			return _width;
		}

	}
}
