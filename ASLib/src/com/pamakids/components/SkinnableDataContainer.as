package com.pamakids.components
{
	import com.pamakids.components.base.Container;
	import com.pamakids.components.base.Skin;
	import com.pamakids.components.interfaces.IItemRendererOwner;
	import com.pamakids.layouts.ILayout;
	import com.pamakids.layouts.VLayout;

	import flash.events.MouseEvent;

	public class SkinnableDataContainer extends Skin implements IItemRendererOwner
	{
		public function SkinnableDataContainer(styleName:String, width:Number=0, height:Number=0, enableBackground:Boolean=false, enableMask:Boolean=false)
		{
			super(styleName, width, height, enableBackground, enableMask);
		}

		public var itemRender:Class;

		public function get dataProvider():Array
		{
			return _dataProvider;
		}

		public function set dataProvider(value:Array):void
		{
			_dataProvider=value;
			renderData();
		}

		public function itemToLabel(item:Object):String
		{
			if (labelFunction != null)
				return labelFunction(item);
			if (item is String)
				return item as String;
			return '';
		}

		public var labelFunction:Function;

		public function updateRenderer(renderer:ItemRenderer, itemIndex:int, data:Object):void
		{
			renderer.owner=this;
			renderer.itemIndex=itemIndex;
			renderer.label=itemToLabel(data);
			renderer.data=data;
		}
		private var _dataProvider:Array;
		protected var container:Container;
		public var contentLayout:ILayout;

		override protected function init():void
		{
			super.init();
			if (!layout)
				layout=new VLayout();
			if (!container)
				container=this;
			container.forceAutoFill=true;
			if (!contentLayout)
				contentLayout=new VLayout();
			container.layout=contentLayout;
			renderData();
		}

		public var selectable:Boolean=true;
		public var selectionMode:String="CALENDAR_MODE";

		/**
		 * 日历的选择模式
		 */
		public static const CALENDAR_MODE:String="CALENDAR_MODE";

		protected function renderData():void
		{
			if (dataProvider && inited && container)
			{
				while (container.numChildren)
				{
					container.removeChildAt(0);
				}
				for each (var data:Object in dataProvider)
				{
					var item:ItemRenderer=new itemRender();
					if (selectable)
						item.addEventListener(MouseEvent.CLICK, selectHandler);
					updateRenderer(item, dataProvider.indexOf(data), data);
					container.addChild(item);
				}
			}
		}

		protected function selectHandler(event:MouseEvent):void
		{
			if (!enabled)
				return;
			var i:ItemRenderer=event.currentTarget as ItemRenderer;
			if (selectionMode == CALENDAR_MODE)
				i.selected=!i.selected;
			else
				i.selected=true;
		}

	}
}
