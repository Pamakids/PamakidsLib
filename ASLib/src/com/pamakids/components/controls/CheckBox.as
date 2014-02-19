package com.pamakids.components.controls
{
	import com.greensock.TweenLite;
	import com.pamakids.components.base.Skin;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	/**
	 * 复选框
	 * @author mani
	 */
	public class CheckBox extends Skin
	{

		private var _label:String;

		public function CheckBox(styleName:String, width:Number=0, height:Number=0)
		{
			super(styleName, width, height, true);
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected=value;
			if (selectedState)
				TweenLite.to(selectedState, 0.3, {alpha: int(value)});
		}

		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
		{
			_label=value;
		}

		override protected function init():void
		{
			super.init();

			updateSkin();
		}

		private var labelHolder:Label;
		private var up:DisplayObject;
		private var selectedState:DisplayObject;
		private var over:DisplayObject;

		private var _selected:Boolean;

		public var hGap:int=8;

		override protected function updateSkin():void
		{
			super.updateSkin();

			up=getBitmap(styleName + 'Up');
			over=getBitmap(styleName + 'Over');
			selectedState=getBitmap(styleName + 'Selected');
			if (!up || !selectedState)
			{
				throw new Error('CheckBox must have up and selected skin');
				return;
			}
			addChild(up);
			if (over)
			{
				addEventListener(MouseEvent.ROLL_OVER, showOver);
				addEventListener(MouseEvent.ROLL_OUT, hideOver);
				over.alpha=0;
				addChild(over);
			}
			selectedState.alpha=0;
			addChild(selectedState);
			addEventListener(MouseEvent.CLICK, clickedHandler);

			labelHolder=new Label(label);
			labelHolder.color=Style.MAIN_COLOR;
			addChild(labelHolder);
			labelHolder.x=up.width + hGap;
			labelHolder.y=(up.height - labelHolder.height) / 2;
			width=labelHolder.x + labelHolder.width;
		}

		protected function clickedHandler(event:MouseEvent):void
		{
			selected=!selected;
		}

		protected function hideOver(event:MouseEvent):void
		{
			if (!selected)
				TweenLite.to(over, 0.3, {alpha: 0});
		}

		protected function showOver(event:MouseEvent):void
		{
			if (!selected)
				TweenLite.to(over, 0.3, {alpha: 1});
		}
	}
}
