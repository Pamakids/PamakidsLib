package com.pamakids.game
{
	import com.pamakids.content.ContentBase;

	/**
	 * 游戏基类
	 * @author mani
	 */
	public class GameBase extends ContentBase
	{
		private var _data:Object;
		private var _life:int;
		private var _totalLife:int;
		private var _totalTime:Number;

		/**
		 * 游戏其它初始化数据值
		 */
		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data=value;
		}

		public function get life():int
		{
			return _life;
		}

		public function set life(value:int):void
		{
			_life=value;
		}

		/**
		 * 游戏初始化数据的属性数组
		 */
		public function get properties():Array
		{
			return null;
		}

		/**
		 * 游戏开始
		 */
		public function start():void
		{

		}

		override protected function say(data:String):void
		{
			dispatchEvent(new GameEvent(data));
		}

		/**
		 * 总生命值
		 * @return
		 */
		public function get totalLife():int
		{
			return _totalLife;
		}

		public function set totalLife(value:int):void
		{
			_totalLife=value;
			_life=value;
		}

		public function get totalTime():Number
		{
			return _totalTime;
		}

		public function set totalTime(value:Number):void
		{
			_totalTime=value;
		}
	}
}
