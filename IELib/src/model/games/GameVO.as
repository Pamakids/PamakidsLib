package model.games
{
	import model.content.ConversationVO;


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
		public var winAlert:ConversationVO;
		public var failureAlert:ConversationVO;
		public var wrongAlert:ConversationVO;
		public var rightAlert:ConversationVO;
	}
}
