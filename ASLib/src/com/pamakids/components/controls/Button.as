package com.pamakids.components.controls
{
	import com.greensock.TweenLite;
	import com.pamakids.components.base.Skin;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * 按钮
	 * @author mani
	 */
	public class Button extends Skin
	{
		protected var upState:DisplayObject;
		protected var downState:DisplayObject;
		protected var overState:DisplayObject;
		private var _enable:Boolean=true;

		private var _label:String;

		public function Button(styleName:String, width:Number=0, height:Number=0)
		{
			super(styleName, width, height, true, false);
			buttonMode=true;
			updateSkin();
		}

		public var color:uint;
		public var fontSize:int=14;

		override protected function init():void
		{
			if (label)
				setLabel();
		}

		private function setLabel():void
		{
			if (!labelControl)
			{
				labelControl=new Label(label);
				labelControl.mouseChildren=labelControl.mouseEnabled=false;
				labelControl.fontSize=fontSize;
				labelControl.color=color;
				addChild(labelControl);
			}
			else
			{
				labelControl.text=label;
			}
			centerDisplayObject(labelControl);
		}

		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
		{
			_label=value;
			if (labelControl)
				labelControl.text=value;
		}

		override protected function updateSkin():void
		{
			disposeBitmap(upState);
			disposeBitmap(downState);
			disposeBitmap(overState);

			upState=getBitmap(styleName + 'Up');
			if (!upState)
			{
				upState=getBitmap(styleName);
				if (!upState)
					throw new Error("Can't find asset：" + styleName);
			}
			addChild(upState);
			overState=getBitmap(styleName + 'Over');
			if (overState)
			{
				overState.alpha=0;
				addChild(overState);
				addEventListener(MouseEvent.ROLL_OVER, onOver);
				addEventListener(MouseEvent.ROLL_OUT, onOut);
			}
			downState=getBitmap(styleName + 'Down');
			if (downState)
			{
				downState.visible=false;
				addChild(downState);
			}
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		protected function onOut(event:MouseEvent):void
		{
			if (overState)
			{
				upState.visible=true;
				TweenLite.to(overState, 0.3, {alpha: 0});
			}
		}

		protected function onOver(event:MouseEvent):void
		{
			if (overState && !event.buttonDown)
			{
				TweenLite.to(overState, 0.3, {alpha: 1, onComplete: function():void
				{
					upState.visible=false;
				}});
			}
		}

		protected function onClick(event:MouseEvent):void
		{
			if (!enabled)
				event.stopImmediatePropagation();
		}

		private var downPoint:Point;

		protected function onMouseDown(event:MouseEvent):void
		{
			if (enabled)
			{
				if (downState)
				{
					if (overState)
						overState.alpha=0;
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
		private var labelControl:Label;

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
