package com.pamakids.components.controls
{
	import com.pamakids.components.base.Skin;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;

	public class PButton extends Skin
	{
		protected var upState:DisplayObject;
		protected var downState:DisplayObject;	
		private var _enable:Boolean=true;
		public function PButton(name:String)
		{
			super(0, 0, true, false);
			upState=getBitmap(name + 'Up');
			downState=getBitmap(name + 'Down');
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
				//stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
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

		public function get enable():Boolean
		{
			return _enable;
		}

		public function set enable(value:Boolean):void
		{
			_enable=value;
			if (!value)//条件
			{
				var rc:Number=1 / 3;
				var gc:Number=1 / 3;
				var bc:Number=1 / 3;
				var cmf:ColorMatrixFilter=new ColorMatrixFilter([rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, 0, 0, 0, 1, 0]);
				filters=[cmf];
			}
			else
			{
				filters=[];
			}
		}

	}
}
