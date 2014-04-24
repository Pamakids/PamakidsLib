package components
{
	import flash.display.Bitmap;
	import flash.display.Sprite;

	import assets.gesture.GestureAssets;

	public class RecommendHint extends Sprite
	{
		public function RecommendHint()
		{
			super();
		}

		private var direction:int;
		private var dirImg:Bitmap;

		public function init():void
		{
			bgSP=new Sprite();
			addChild(bgSP);

			var bg:Bitmap=new GestureAssets.gesture_bg();
			bgSP.addChild(bg);
			bgSP.x=1024 - bg.width >> 1;
			bgSP.y=768 - bg.height >> 1;

//			var word:Bitmap=new RecomendAssets.GESWORD();
//			word.x=94;
//			word.y=100;
//			bgSP.addChild(word);
		}

		private var active:Boolean=false;

		public function getCurrentDir():String
		{
			return dirArr[direction];
		}

		private var dirArr:Array=["up", "down", "left", "right"];

		private var bgSP:Sprite;

		public function getRandomGesture():void
		{
			if (dirImg && bgSP.contains(dirImg))
				bgSP.removeChild(dirImg);
			dirImg=null;
			direction=Math.random() * 4;
			var cls:Class;
			cls=GestureAssets["gesture_" + dirArr[direction]];
			dirImg=new cls();
			bgSP.addChild(dirImg);
			dirImg.x=50;
			dirImg.y=125;
		}
	}
}

