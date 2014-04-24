package com.pamakids
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;

	public class FullFillBG extends Sprite
	{

		[Embed(source="land_left.jpg")]
		private static var leftBG:Class;
		[Embed(source="land_right.jpg")]
		private static var rightBG:Class;

		public function FullFillBG()
		{
			super();

			if (!stage)
				addEventListener(Event.ADDED_TO_STAGE, inits);
			else
				inits(null);
		}

		protected function inits(event:Event):void
		{
			var w:Number=Math.max(stage.fullScreenHeight, stage.fullScreenWidth);
			var h:Number=Math.min(stage.fullScreenHeight, stage.fullScreenWidth);

			var scale:Number=0;
			var offsetX:Number=0
			var offsetY:Number=0;
			if (h / 768 > w / 1024)
			{
				scale=w / 1024;
				offsetY=(h - 768 * scale) / 2;
			}
			else
			{
				scale=h / 768;
				offsetX=(w - 1024 * scale) / 2;
			}

			var left:Bitmap=new leftBG();
			var right:Bitmap=new rightBG();

			addChild(left);
			addChild(right);

			left.width=offsetX+1;
			right.width=offsetX+1;
			left.height=right.height=h;

			right.x=w-right.width;

			this.mouseChildren=this.mouseEnabled=false;
		}
	}
}

