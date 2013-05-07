package com.pamakids.content
{
	import flash.display.Sprite;
	import flash.events.DataEvent;

	public class ContentBase extends Sprite implements IContent
	{
		private var _width:Number;
		private var _height:Number;

		public function ContentBase()
		{
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
			dispatchEvent(new DataEvent(DataEvent.DATA, false, false, data));
		}

		/**
		 * 释放内容
		 */
		public function dispose():void
		{

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
