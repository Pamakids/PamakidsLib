package com.pamakids.components.controls
{
	import com.pamakids.components.base.Skin;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class Button extends Skin
	{
		protected var upState:DisplayObject;
		protected var downState:DisplayObject;
		private var _enable:Boolean=true;

		public function Button(styleName:String)
		{
			super(styleName, 0, 0, true, false);
			updateSkin();
		}

		override protected function updateSkin():void
		{
			if (upState)
				removeChild(upState);
			if (downState)
				removeChild(downState);

			upState=getBitmap(styleName + 'Up');
			if (!upState)
			{
				upState=getBitmap(styleName);
				if (!upState)
					throw new Error("Can't find asset：" + styleName);
			}
			downState=getBitmap(styleName + 'Down');
			if (downState)
			{
				downState.visible=false;
				addChild(downState);
			}
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addChild(upState);
		}

		protected function onClick(event:MouseEvent):void
		{
			if (!enable)
				event.stopImmediatePropagation();
		}

		private var downPoint:Point;

		protected function onMouseDown(event:MouseEvent):void
		{
			if (enable)
			{
				if (downState)
				{
					upState.visible=false;
					downState.visible=true;
				}
				downPoint=new Point(event.stageX, event.stageY);
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			else
			{
				event.stopImmediatePropagation();
			}
		}

		/**
		 * 按下后移动超出38像素
		 */
		protected var downAndMoved:Boolean;

		protected function onMouseUp(event:MouseEvent):void
		{
			var p:Point=new Point(event.stageX, event.stageY);
			var distance:Number=Point.distance(downPoint, p);
			if (distance > 38)
				downAndMoved=true;
			upState.visible=true;
			if (downState)
				downState.visible=false;
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		override protected function dispose():void
		{
			super.dispose();
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

	}
}
