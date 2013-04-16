package
{
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;

	/**
	 * data 游戏数据，通过传递数据来调整游戏状态等
	 * start() 开始游戏
	 * init() 将游戏添加到舞台上
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
		 * 游戏配置数据,比如当前游戏的难度之类
		 * @param data
		 */
		function set data(data:Object):void;
		function get data():Object;
		function get properties():Array;
		function start():void;
		function init(parent:DisplayObjectContainer):void;
		function close():void;
	}

}

