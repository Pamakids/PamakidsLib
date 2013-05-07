package com.pamakids.game
{
	import flash.events.IEventDispatcher;

	/**
	 * data 游戏数据，通过传递数据来调整游戏状态等
	 * start() 开始游戏
	 * initialize() 初始化游戏
	 * close() 关闭游戏
	 * events:
	 * 		GAME_OVER: 游戏结束后派发该事件
	 */
	public interface IGame extends IEventDispatcher
	{
		/**
		 * 目标积分，达到该积分后游戏结束
		 * @param score
		 */
		function set goalScore(score:int):void;
		function get goalScore():int;
		/**
		 * 用户获得的积分
		 * @param score
		 */
		function set score(score:int):void;
		function get score():int;
		/**
		 * 当前生命值，生命值为0后，游戏结束
		 * @param life
		 */
		function set life(life:int):void;
		function get life():int;
		/**
		 * 总生命值
		 * @param life
		 */
		function set totalLife(life:int):void;
		function get totalLife():int;
		/**
		 * 游戏总时间，时间结束，游戏结束
		 */
		function set totalTime(time:int):void;
		/**
		 * 游戏配置数据,比如当前游戏的难度之类
		 * @param data
		 */
		function set data(data:Object):void;
		function get data():Object;
		function get properties():Array;

		function start():void;
		function initialize(width:Number, height:Number):void;
		function close():void;
		function set paused(value:Boolean):void;
		function get paused():Boolean;
	}

}

