package com.pamakids.helper
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 外部点击助手
	 * @author mani
	 */
	public class OutClickHelper
	{
		private var callback:Function;
		private var target:DisplayObject;
		public var enable:Boolean=true;

		public function OutClickHelper(target:DisplayObject, callback:Function)
		{
			this.target=target;
			this.callback=callback;
			if (!target.stage)
				target.addEventListener(Event.ADDED_TO_STAGE, onStageHandler);
			else
				target.stage.addEventListener(MouseEvent.CLICK, stageClickedHandler);
			target.addEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
			target.addEventListener(MouseEvent.CLICK, targetClickedHandler);
		}

		protected function onStageHandler(event:Event):void
		{
			target.removeEventListener(Event.ADDED_TO_STAGE, onStageHandler);
			target.stage.addEventListener(MouseEvent.CLICK, stageClickedHandler);
		}

		private var isClicked:Boolean;

		protected function targetClickedHandler(event:Event):void
		{
			event.stopImmediatePropagation();
		}

		protected function removedHandler(event:Event):void
		{
			callback=null;
			target.stage.removeEventListener(MouseEvent.CLICK, stageClickedHandler);
			target.removeEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
			target.removeEventListener(MouseEvent.CLICK, targetClickedHandler);
		}

		protected function stageClickedHandler(event:MouseEvent):void
		{
			if (!enable)
				return;
			if (!isClicked)
			{
				enable=false;
				callback();
			}
			else
			{
				isClicked=false;
			}
		}
	}
}
