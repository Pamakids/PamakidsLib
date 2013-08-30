package com.pamakids.components
{
	import com.pamakids.components.base.Container;
	import com.pamakids.components.controls.Label;

	public class ItemRenderer extends Container
	{
		public function ItemRenderer(width:Number=0, height:Number=0, enableBackground:Boolean=false, enableMask:Boolean=false)
		{
			super(width, height, enableBackground, enableMask);
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
			if (labelHolder)
				labelHolder.text=value;
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected=value;
		}

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data=value;
			renderData();
		}

		/**
		 * 渲染数据
		 */
		protected function renderData():void
		{
			if (inited)
			{
				if (label)
				{
					labelHolder=new Label(label);
					addChild(labelHolder);
				}
			}
		}

		private var _itemIndex:int;
		private var _label:String;
		private var _selected:Boolean;
		protected var labelHolder:Label;

		override protected function init():void
		{
			super.init();
			renderData();
		}

	}
}
