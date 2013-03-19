package com.pamakids.components.controls
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class PToggleButton extends PButton
	{
		public function PToggleButton(name:String, selected:String='', required:Boolean=false)
		{
			super(name);
			if (selected)
			{
				selectedState=getBitmap(selected);
				selectedState.visible=false;
				addChild(selectedState);
			}
			this.required=required;
		}

		protected var selectedState:DisplayObject;

		private var _selected:Boolean;
		private var required:Boolean;

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected=value;
			if (selectedState)
				selectedState.visible=value;
			upState.visible=!value;
		}

		override protected function onMouseDown(event:MouseEvent):void
		{
			super.onMouseDown(event);
			if (!required)
				selected=!selected;
			else if (!selected)
				selected=true;
		}

		override protected function onMouseUp(event:MouseEvent):void
		{
			super.onMouseUp(event);
			upState.visible=!selected;
		}
	}
}
