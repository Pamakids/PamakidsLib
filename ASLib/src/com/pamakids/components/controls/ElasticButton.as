package com.pamakids.components.controls
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;
	import com.pamakids.components.controls.Button;

	import flash.events.MouseEvent;
	import flash.utils.setTimeout;

	/**
	 * 弹簧按钮
	 * @author mani
	 */
	public class ElasticButton extends Button
	{
		public function ElasticButton(styleName:String)
		{
			super(styleName);
		}

		private var playingEffect:Boolean;

		override protected function onClick(event:MouseEvent):void
		{
			if (stopClickEvent || downAndMoved)
				event.stopImmediatePropagation();
			else
				stopClickEvent=true;
		}

		override protected function onMouseDown(event:MouseEvent):void
		{
			if (playingEffect)
				return;
			super.onMouseDown(event);
			playingEffect=true;
			var vars:Object={transformAroundCenter: {scaleX: 0.6, scaleY: 0.6}, onComplete: downComplete, ease: Cubic.easeIn}
			TweenMax.to(this, 0.3, vars);
		}

		private function downComplete():void
		{
			downCompleted=true;
			if (upCompleted)
				doUp();
		}

		private var upCompleted:Boolean;
		private var downCompleted:Boolean;

		override protected function onMouseUp(event:MouseEvent):void
		{
			super.onMouseUp(event);
			upCompleted=true;
			if (downCompleted)
				doUp();
		}

		private function doUp():void
		{
			var vars:Object={transformAroundCenter: {scaleX: 1, scaleY: 1}, onComplete: upComplete, ease: Elastic.easeOut}
			TweenMax.to(this, 0.5, vars);
		}

		private var stopClickEvent:Boolean=true;

		private function upComplete():void
		{
			setTimeout(function():void
			{
				playingEffect=false;
				upCompleted=false;
				downCompleted=false;
			}, 500);

			if (!downAndMoved)
			{
				stopClickEvent=false;
				dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			else
			{
				stopClickEvent=true;
				downAndMoved=false;
			}
		}
	}
}
