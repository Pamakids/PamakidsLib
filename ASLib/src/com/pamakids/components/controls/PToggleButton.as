package com.pamakids.components.controls
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class PToggleButton extends PButton
	{
		protected var selectedState:DisplayObject;
		private var _selected:Boolean;
		private var required:Boolean;
		public function PToggleButton(name:String,selectedIconLocation:String='', required:Boolean=false)
		{
			super(name);
			if (selectedIconLocation)
			{
				selectedState=getBitmap(selectedIconLocation);
				selectedState.visible=false;
				addChild(selectedState);
			}
			this.required=required;//将全局设为false
		}
		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected=value;
			
			if (selectedState)//条件
				selectedState.visible=value;
			upState.visible=!value;
		}

		override protected function onMouseDown(event:MouseEvent):void
		{
			
			super.onMouseDown(event);
			
			if (!required)//这个   "反" 是外部类调用的时候改的?
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
