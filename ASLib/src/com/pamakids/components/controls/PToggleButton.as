package com.pamakids.components.controls
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class PToggleButton extends PButton
	{
		protected var selectedState:DisplayObject;
		private var _selected:Boolean;

		/**
		 * 如果为true，只可开不可关；false则可开关
		 */
		private var required:Boolean;
		private var selectedIconLocation:String;

		public function PToggleButton(name:String, selectedIconLocation:String='', required:Boolean=false)
		{
			super(name);
			this.selectedIconLocation=selectedIconLocation;
			initSelectedState();
			this.required=required;
		}

		private function initSelectedState():void
		{
			if (selectedState)
				removeChild(selectedState);

			if (selectedIconLocation)
			{
				selectedState=getBitmap(selectedIconLocation);
				selectedState.visible=selected;
				addChild(selectedState);
			}
		}

		override protected function updateSkin():void
		{
			super.updateSkin();
			initSelectedState();
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected=value;

			if (selectedState) //条件
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
