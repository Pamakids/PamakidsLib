package com.pamakids.helper
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * 点击助手
	 * @author mani
	 */
	public class ClickEventHelper
	{
		private var callback:Function;
		private var target:DisplayObject;
		private var stage:Stage;
		private var downPoint:Point;

		public function ClickEventHelper(target:DisplayObject, clickHandler:Function)
		{
			this.target=target;
			callback=clickHandler;
			if (!target.stage)
				target.addEventListener(Event.ADDED_TO_STAGE, onStageHandler);
			else
				this.stage=target.stage;
			target.addEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
			target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}

		protected function onStageHandler(event:Event):void
		{
			target.removeEventListener(Event.ADDED_TO_STAGE, onStageHandler);
			this.stage=target.stage;
		}

		protected function removeHandler(event:Event):void
		{
			trace('Removed Helper Target:' + target);
			target.removeEventListener(Event.REMOVED_FROM_STAGE, removeHandler);
			target.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			target=null;
			callback=null;
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage=null;
		}

		protected function mouseDownHandler(event:MouseEvent):void
		{
			downPoint=new Point(event.stageX, event.stageY);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
		}

		protected function mouseUpHandler(event:MouseEvent):void
		{
			if (stage)
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			var p:Point=new Point(event.stageX, event.stageY);
			if (Point.distance(downPoint, p) < 38)
				callback();
		}
	}
}
