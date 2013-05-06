package model.games
{

	[Bindable]
	public class GameVO
	{

		public function GameVO()
		{
		}

		public var name:String;
		public var goalScore:int;
		public var score:int;
		public var life:int;
		public var totalLife:int;
		public var properties:Array;
		public var totalTime:int;
		public var url:String;
		/**
		 * 游戏类型
		 */
		public var type:String;
		public var winAlert:String;
		public var failureAlert:String;
		public var wrongAlert:String;
		public var rightAlert:String;
		public var pauseAlert:String;
	}
}
