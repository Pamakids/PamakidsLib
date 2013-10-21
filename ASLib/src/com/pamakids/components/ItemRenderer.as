package com.pamakids.components
{
	import com.pamakids.components.base.Skin;
	import com.pamakids.components.controls.Label;

	import flash.events.Event;

	[Event(name="change", type="flash.events.Event")]
	public class ItemRenderer extends Skin
	{
		public function ItemRenderer(width:Number=0, height:Number=0, enableBackground:Boolean=false, enableMask:Boolean=false)
		{
			super('', width, height, enableBackground, enableMask);
		}

		private var _data:Object;
		public var owner:SkinnableDataContainer;

		public function get itemIndex():int
		{
			return _itemIndex;
		}

		public function set itemIndex(value:int):void
		{
			_itemIndex=value;
		}

		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
		{
			if (value == _label)
				return;
			_label=value;
			renderData();
//			if (labelHolder)
//				labelHolder.text=value;
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		private var changed:Boolean;

		public function set selected(value:Boolean):void
		{
			changed=value != _selected;
			_selected=value;
			if (changed)
				dispatchEvent(new Event(Event.CHANGE, true));
		}

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data=value;
			renderData(false);
		}

		/**
		 * 渲染数据
		 */
		protected function renderData(clear:Boolean=false):void
		{
			if (inited)
			{
				if (clear)
				{
					while (numChildren)
					{
						removeChildAt(0);
					}
					labelDisplay=null;
				}
				if (label)
				{
					if (!labelDisplay)
					{
						labelDisplay=new Label(label);
						addChild(labelDisplay);
					}
					else
					{
						labelDisplay.text=label;
					}
				}
			}
		}

		private var _itemIndex:int;
		private var _label:String;
		protected var _selected:Boolean;
		protected var labelDisplay:Label;

		override protected function init():void
		{
			super.init();
			renderData();
		}

	}
}
