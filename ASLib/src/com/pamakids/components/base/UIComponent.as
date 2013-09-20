package com.pamakids.components.base
{
	import com.pamakids.events.ResizeEvent;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * 控件基类
	 * @author mani
	 */
	public class UIComponent extends Sprite
	{
		public function UIComponent(width:Number=0, height:Number=0)
		{
			if (!width && !height)
				autoFill=true;
			setSize(width, height);
			startTime=getTimer();
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}

		/**
		 * 根据子项最大宽高设置宽高
		 */
		public function get autoFill():Boolean
		{
			return _autoFill;
		}

		public function set autoFill(value:Boolean):void
		{
			if (forceAutoFill)
				value=forceAutoFill;
			_autoFill=value;
		}

		public function get startTime():int
		{
			if (!hasEventListener(Event.ACTIVATE))
				addEventListener(Event.ACTIVATE, onRefreshingTime);
			return _startTime;
		}

		public function set startTime(value:int):void
		{
			_startTime=value;
		}

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			_enabled=value;
			mouseChildren=mouseEnabled=value;
			alpha=value ? 1 : .5;
		}

		protected var inited:Boolean;

		protected function onStage(event:Event):void
		{
			inited=true;
			if (autoDispose)
				removeEventListener(Event.ADDED_TO_STAGE, onStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			init();
		}

		public var autoDispose:Boolean=true;

		protected function onRemoved(event:Event):void
		{
			if (autoDispose)
			{
				removeEventListener(Event.ADDED_TO_STAGE, onStage);
				removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
				dispose();
			}
		}

		/**
		 * 释放内存
		 */
		protected function dispose():void
		{
			removeEventListener(Event.ACTIVATE, onRefreshingTime);
		}

		/**
		 * 组件添加到舞台上后开始
		 */
		protected function init():void
		{
		}

		public var minHeight:Number;
		public var minWidth:Number;

		protected function onRefreshingTime(event:Event):void
		{
			startTime=getTimer() - startTime;
		}

		public function get forceAutoFill():Boolean
		{
			return _forceAutoFill;
		}

		public function set forceAutoFill(value:Boolean):void
		{
			_forceAutoFill=value;
		}

		private var _height:Number;
		private var _width:Number;
		protected var sizeChanged:Boolean=true;

		override public function set width(value:Number):void
		{
			if (_width != value)
			{
				_width=value;
				sizeChanged=true;
				resize();
			}
		}

		private var _forceAutoFill:Boolean;
		private var _autoFill:Boolean;

		/**
		 * 将所有子项自动居中
		 */
		public function get autoCenter():Boolean
		{
			return _autoCenter;
		}

		private var _autoCenter:Boolean;

		/**
		 * @private
		 */
		public function set autoCenter(value:Boolean):void
		{
			_autoCenter=value;
		}

		protected function resize():void
		{
			if (_width || _height)
			{
				autoFill=forceAutoFill;
				if (sizeChanged)
				{
					sizeChanged=false;
					dispatchEvent(new ResizeEvent(_width, _height));
				}
			}
			centerChildren();
		}

		private function centerChildren():void
		{
			if (autoCenter)
			{
				for (var i:int; i < numChildren; i++)
				{
					centerDisplayObject(getChildAt(i));
				}
			}
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			autoSetSize(child);
			return super.addChild(child);
		}

		public var centerOffsetY:int;

		protected function centerDisplayObject(child:DisplayObject):void
		{
			child.x=width / 2 - child.width / 2;
			child.y=height / 2 - child.height / 2 + centerOffsetY;
		}

		protected function autoSetSize(child:DisplayObject):void
		{
			if (autoFill || forceAutoFill)
				setSize(child.width > width ? child.width : width, child.height > height ? child.height : height);
		}

		public function setSize(width:Number, height:Number):void
		{
			if (minWidth && width < minWidth)
				width=minWidth;
			if (minHeight && height < minHeight)
				height=minHeight;
			if (width != _width || height != _height)
				sizeChanged=true;
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
			if (value != _height)
			{
				_height=value;
				sizeChanged=true;
				resize();
			}
		}

		override public function get width():Number
		{
			return _width;
		}

		private var _enabled:Boolean=true;
		private var _startTime:int;
	}
}
