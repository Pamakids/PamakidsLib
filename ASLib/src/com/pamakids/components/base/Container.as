package com.pamakids.components.base
{
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

		protected function onStage(event:Event):void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
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
		private var enableMask:Boolean;

		public function get enableBackground():Boolean
		{
			return _enableBackground;
		}

		public function set enableBackground(value:Boolean):void
		{
			_enableBackground=value;
			drawBackground();
		}

		private function drawBackground():void
		{
			if (!width || !height || !enableBackground)
				return;

			graphics.clear();
			graphics.beginFill(0, 0);
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
			if (centerFill)
				centerDisplayObject(child);
			if (autoFill)
			{
				width=child.width > width ? child.width : width;
				height=child.height > height ? child.height : height;
			}
			return super.addChild(child);
		}

		private function centerDisplayObject(d:DisplayObject):void
		{
			d.x=width / 2 - d.width / 2;
			d.y=height / 2 - d.height / 2;
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

		private function resize():void
		{
			if (width || height)
			{
				autoFill=false;
				centerChildren();
				drawBackground();
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
