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
	}
}
