package com.pamakids.components.controls
{
	import com.pamakids.components.base.Skin;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

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
				addChild(downState);
				addEventListener(MouseEvent.CLICK, onClick);
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
			addChild(upState);
		}

		protected function onClick(event:MouseEvent):void
		{
			if (!enable)
				event.stopImmediatePropagation();
		}

		protected function onMouseDown(event:MouseEvent):void
		{
			if (enable)
			{
				upState.visible=false;
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			else
			{
				event.stopImmediatePropagation();
			}
		}

		protected function onMouseUp(event:MouseEvent):void
		{
			upState.visible=true;
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		override protected function dispose():void
		{
			super.dispose();
			removeEventListener(MouseEvent.CLICK, onClick);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

	}
}
