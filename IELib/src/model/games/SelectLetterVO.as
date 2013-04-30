package model.games
{

	public class SelectLetterVO extends GameVO
	{
		public function SelectLetterVO()
		{
			super();
			assetsDir = "/assets/games/selectLetter/";
			gameUrl = "/assets/games/selectLetter/SelectLetter.swf";
		}

		/**
		 * 要拼写的单词
		 */		
		public var word:String;

		override protected function promptThis():void
		{
			super.promptThis();
			prompts["word"] = '要拼写的单词';
		}

	}
}

