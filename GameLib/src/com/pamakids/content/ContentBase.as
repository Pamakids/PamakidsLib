package com.pamakids.content
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class ContentBase extends Sprite implements IContent
	{
		private var _width:Number;
		private var _height:Number;

		protected var isDebugMode:Boolean;

		public function ContentBase()
		{
			if (stage)
			{
				stage.scaleMode=StageScaleMode.NO_SCALE;
				stage.align=StageAlign.TOP_LEFT;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				isDebugMode=true;
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, onStage);
			}
		}

		protected function clearChildren():void
		{
			while (numChildren)
			{
				var o:Object=removeChildAt(0);
				if (o is MovieClip)
				{
					(o as MovieClip).stop();
				}
				else if (o is Bitmap)
				{
					var b:Bitmap=o as Bitmap;
					if (b.bitmapData)
						b.bitmapData.dispose();
				}
			}
		}

		public function get pause():Boolean
		{
			return _pause;
		}

		public function set pause(value:Boolean):void
		{
			_pause=value;
		}

		protected function onStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			init();
		}

		protected function keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ENTER)
			{
				if (disposed)
					init();
				else
					dispose();
			}
			else if (event.keyCode == Keyboard.P)
			{
				pause=!pause;
			}
		}

		/**
		 * 通过外部给内容设定状态
		 */
		public function get state():String
		{
			return _state;
		}

		public function set state(value:String):void
		{
			_state=value;
		}

		/**
		 * 告诉编辑器当前内容触发了什么事件
		 * @param data 事件数据，跟events列表里的事件数据对应
		 *
		 */
		protected function say(data:String):void
		{
			trace('Say:', data);
			dispatchEvent(new DataEvent(DataEvent.DATA, true, false, data));
		}

		protected var disposed:Boolean;

		/**
		 * 释放内容
		 */
		public function dispose():void
		{
			disposed=true;
		}

		private var _state:String;

		/**
		 * 返回互动内容存在的状态列表
		 */
		public function get states():Array
		{
			return null;
		}

		/**
		 * 返回互动内容可向外派发的事件列表
		 */
		public function get events():Array
		{
			return null;
		}

		public function initialize(width:Number, height:Number):void
		{
			this.width=width;
			this.height=height;
		}

		protected function init():void
		{
			disposed=false;
		}

		private var _pause:Boolean;

		override public function set width(value:Number):void
		{
			_width=value;
		}

		override public function get width():Number
		{
			return _width;
		}

		override public function get height():Number
		{
			return _height;
		}

		override public function set height(value:Number):void
		{
			_height=value;
		}

	}
}
