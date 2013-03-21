package com.pamakids.components.controls
{
	import com.pamakids.components.base.Skin;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;

	public class PButton extends Skin
	{
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

		protected var upState:DisplayObject;       //向上的状态
		protected var downState:DisplayObject;         //在下面

		private var _enable:Boolean=true;           

		public function get enable():Boolean
		{
			return _enable; 
		}

		/**
		 *这里应该是加的一个状态 ，灰色
		 * @param value
		 * 
		 */		
		public function set enable(value:Boolean):void
		{
			_enable=value;
			if (!value)
			{
				var rc:Number=1 / 3;
				var gc:Number=1 / 3;
				var bc:Number=1 / 3;
				var cmf:ColorMatrixFilter=new ColorMatrixFilter([rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, 0, 0, 0, 1, 0]);//用指定参数初始化新的 ColorMatrixFilter 实例。
				//参数:
				//matrix 由 20 个项目（排列成 4 x 5 矩阵）组成的数组。

				filters=[cmf];
			}
			else
			{
				filters=[];
			}
		}

	}
}
