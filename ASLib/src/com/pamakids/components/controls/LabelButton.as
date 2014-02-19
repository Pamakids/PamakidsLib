package com.pamakids.components.controls
{
	import com.pamakids.components.base.Container;

	import flash.events.MouseEvent;

	/**
	 * 文本按钮
	 * @author mani
	 */
	public class LabelButton extends Container
	{
		public function LabelButton(label:String, width:Number=0, height:Number=0)
		{
			this.label=label;
			super(width, height, true);
			buttonMode=true;
		}

		public var label:String;
		private var l:Label;
		public var fontSize:int=17;
		private var _color:uint;

		public function get color():uint
		{
			return _color ? _color : Style.MAIN_COLOR;
		}

		public function set color(value:uint):void
		{
			_color=value;
		}

		override protected function init():void
		{
			l=new Label(label, width, height);
			l.mouseEnabled=l.mouseChildren=false;
			l.fontSize=fontSize;
			l.color=color;
			l.alpha=.6;
			addChild(l);

			addEventListener(MouseEvent.ROLL_OVER, overHandler);
			addEventListener(MouseEvent.ROLL_OUT, outHandler);
		}

		protected function outHandler(event:MouseEvent):void
		{
			l.alpha=.6;
		}

		protected function overHandler(event:MouseEvent):void
		{
			l.alpha=1;
		}
	}
}
