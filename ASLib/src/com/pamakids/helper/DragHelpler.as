package com.pamakids.helper
{
	import com.pamakids.events.ResizeEvent;

	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * 拖拽助手
	 * @author mani
	 */
	public class DragHelpler
	{
		private var target:DisplayObject;
		private var stage:Stage;
		private var downPoint:Point;
		private var targetPoint:Point;
		private var miniX:Number;
		private var miniY:Number;
		private var container:DisplayObject;

		public var enable:Boolean=true;

		public function DragHelpler(target:DisplayObject, container:DisplayObject)
		{
			this.target=target;
			stage=container.stage;
			miniX=container.width - target.width;
			miniY=container.height - target.height;
			target.addEventListener(Event.REMOVED_FROM_STAGE, targetRemovedHandler);
			target.addEventListener(MouseEvent.MOUSE_DOWN, downTargetHandler);
			target.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			container.addEventListener(ResizeEvent.RESIZE, resizeHandler);
			this.container=container;
		}

		protected function resizeHandler(event:Event):void
		{
			miniX=container.width - target.width;
			miniY=container.height - target.height;
		}

		protected function targetRemovedHandler(event:Event):void
		{
			target.removeEventListener(Event.REMOVED_FROM_STAGE, targetRemovedHandler);
			target.removeEventListener(MouseEvent.MOUSE_DOWN, downTargetHandler);
			target.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}

		protected function onRemoved(event:Event):void
		{
			event.target.removeEventListener(MouseEvent.MOUSE_DOWN, downTargetHandler);
			event.target.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			container.addEventListener(ResizeEvent.RESIZE, resizeHandler);
		}

		protected function downTargetHandler(event:MouseEvent):void
		{
			downPoint=new Point(event.stageX, event.stageY);
			targetPoint=new Point(target.x, target.y);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
		}

		protected function upHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
		}

		protected function moveHandler(event:MouseEvent):void
		{
			if (!enable)
				return;
			var tx:Number=targetPoint.x + (event.stageX - downPoint.x);
			var ty:Number=targetPoint.y + (event.stageY - downPoint.y);
			if (tx > 0)
				tx=0;
			else if (tx < miniX)
				tx=miniX;
			if (miniY < 0)
			{
				if (ty > 0)
					ty=0;
				else if (ty < miniY)
					ty=miniY;
			}
			else
			{
				if (ty < 0)
					ty=0;
				else if (ty > miniY)
					ty=miniY;
			}
			target.x=tx;
			target.y=ty;
		}
	}
}
