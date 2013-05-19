package com.pamakids.components.controls
{
	import com.pamakids.components.base.Container;
	import com.pamakids.events.IndexEvent;
	import com.pamakids.layouts.HLayout;
	import com.pamakids.layouts.VLayout;
	import com.pamakids.layouts.base.LayoutBase;
	import com.pamakids.vo.ButtonVO;

	import flash.events.MouseEvent;

	public class ButtonBar extends Container
	{

		private var dataProvider:Array;
		public var gap:Number=8;
		public var itemWidth:Number;
		public var itemHeight:Number;
		private var buttons:Array=[];

		public var selectable:Boolean=true;
		public var onlySelectedOne:Boolean=true;
		public var clickable:Boolean=true;

		public function ButtonBar(dataProvider:Array, direction:String="HORIZONTAL", width:Number=0, height:Number=0)
		{
			super(width, height);
			this.dataProvider=dataProvider;

			if (direction == LayoutBase.HORIZONTAL)
				layout=new HLayout();
			else if (direction == LayoutBase.VERTICAL)
				layout=new VLayout();
		}

		override protected function init():void
		{
			layout.gap=gap;
			layout.itemWidth=itemWidth;
			layout.itemHeight=itemHeight;
			for each (var o:ButtonVO in dataProvider)
			{
				var pb:Button=selectable && o.selectable ? new ToggleButton(o.name, o.selected, o.required) : new Button(o.name);
				buttons.push(pb);
				if (clickable)
					pb.addEventListener(MouseEvent.CLICK, onClick);
				pb.autoCenter=true;
				addChild(pb);
			}
		}

		private var selectedItem:ToggleButton;

		public function selectedIndex(index:int):void
		{
			if (selectedItem)
				selectedItem.selected=false;
			selectedItem=getChildAt(index) as ToggleButton;
			selectedItem.selected=true;
		}

		protected function onClick(event:MouseEvent):void
		{
			dispatchEvent(new IndexEvent(buttons.indexOf(event.currentTarget), event.currentTarget));
			if (selectable && onlySelectedOne)
			{
				for each (var pb:ToggleButton in buttons)
				{
					if (pb != event.currentTarget)
						pb.selected=false;
				}
			}
		}

		override protected function dispose():void
		{
			for each (var pb:ToggleButton in buttons)
			{
				pb.removeEventListener(MouseEvent.CLICK, onClick);
			}
			buttons.length=0;
			buttons=null;
		}
	}
}
