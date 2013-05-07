package views.game
{
	import com.greensock.TweenLite;
	import com.pamakids.components.base.Skin;

	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import views.components.ElasticButton;

	[Event(name="resume", type="flash.events.Event")]
	[Event(name="playAgain", type="flash.events.Event")]
	[Event(name="nextPage", type="flash.events.Event")]
	public class GameResultBox extends Skin
	{
		public function GameResultBox(styleName:String="gameBox", width:Number=457, height:Number=317)
		{
			super(styleName, width, height, false, false);
		}

		override protected function updateSkin():void
		{
			super.updateSkin();

			var bitmap:Bitmap;
			bitmap=getBitmap(styleName + 'BG');
			bitmap.y=58;
			addChild(bitmap);
			if (state)
			{
				bitmap=getBitmap(state);
				bitmap.x=133;
				addChild(bitmap);
			}
			var b:ElasticButton;
			if (state != PAUSE)
			{
				b=new ElasticButton('playAgain');
				b.x=151;
				b.y=230;
				b.addEventListener(MouseEvent.CLICK, playAgainHandler);
				addChild(b);
				if (state == WIN)
				{
					showLifeIcons();
					b=new ElasticButton('gameNext');
					b.x=parent.width - b.width - 40 - x;
					b.y=parent.height - b.height - 40 - y;
					b.addEventListener(MouseEvent.CLICK, nextPageHandler);
					addChild(b);
				}
			}
			else
			{
				b=new ElasticButton('resumeGame');
				b.x=151;
				b.y=230;
				b.addEventListener(MouseEvent.CLICK, resumeGameHandler);
				addChild(b);
			}
		}

		override protected function dispose():void
		{
			for (var i:int; i < numChildren; i++)
			{
				var b:ElasticButton=getChildAt(i) as ElasticButton;
				if (b)
				{
					switch (b.styleName)
					{
						case 'playAgain':
							b.removeEventListener(MouseEvent.CLICK, playAgainHandler);
							break;
						case 'gameNext':
							b.removeEventListener(MouseEvent.CLICK, nextPageHandler);
							break;
						case 'resumeGame':
							b.removeEventListener(MouseEvent.CLICK, resumeGameHandler);
							break;
					}
				}
			}
			super.dispose();
		}

		protected function nextPageHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event('nextPage'));
		}

		public var life:int;

		private function showLifeIcons():void
		{
			var startX:Number=171;
			var startY:Number=154;
			var preIcon:Bitmap;
			for (var i:int; i < life; i++)
			{
				var icon:Bitmap=getBitmap('lifeIcon');
				if (!preIcon)
					icon.x=startX;
				else
					icon.x=preIcon.x + preIcon.width + 8;
				preIcon=icon;
				icon.y=startY;
				icon.alpha=0;
				addChild(icon);
				TweenLite.to(icon, 0.3, {delay: i * 0.3, alpha: 1});
			}
		}

		protected function resumeGameHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event('resume'));
		}

		protected function playAgainHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event('playAgain'));
		}

		public var state:String;

		public static const WIN:String="gameWin";
		public static const FAILURE:String="gameFailure";
		public static const PAUSE:String="gamePause";

		override protected function init():void
		{
			super.init();
			updateSkin();
		}

	}
}
