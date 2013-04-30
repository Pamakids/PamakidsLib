package model.content
{
	import model.games.GameVO;

	/**
	 * 热区VO，用作不同时间在影片显示不同内容
	 * @author mani
	 */
	public class HotAreaVO
	{
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;

		/**
		 * 热区类型，对应HotType
		 */
		public var type:String;

		/**
		 * 不同类型对应的不同资源地址
		 * 可以是音频、SWF、图片、游戏等
		 * 也可以是命令调用的代号
		 */
		public var url:String;

		/**
		 * 热区绘制的commands
		 */
		public var commands:String;

		/**
		 * 热区绘制的commands
		 */
		public var coords:String;

		/**
		 * 出现页数
		 */
		public var page:int;
		public var gameVO:GameVO;
	}
}

