package com.pamakids.components.controls
{
	import com.pamakids.components.base.Container;
	import com.pamakids.events.IndexEvent;
	import com.pamakids.layouts.HLayout;
	import com.pamakids.layouts.ILayout;
	import com.pamakids.layouts.VLayout;
	import com.pamakids.layouts.base.LayoutBase;

	import flash.events.MouseEvent;

	public class PButtonBar extends Container
	{

		private var dataProvider:Array;
		private var layout:ILayout;
		public var gap:Number=8;
		public var itemWidth:Number;
		public var itemHeight:Number;
		private var buttons:Array=[];

		public var selectable:Boolean=true;

		public function PButtonBar(dataProvider:Array, direction:String=LayoutBase.HORIZONTAL, width:Number=0, height:Number=0)
		{
			super(width, height);
			this.dataProvider=dataProvider;

			if (direction == LayoutBase.HORIZONTAL)
				layout=new HLayout(this);
			else if (direction == LayoutBase.VERTICAL)
				layout=new VLayout(this);
		}

		override protected function init():void
		{
			layout.gap=gap;
			layout.itemWidth=itemWidth;
			layout.itemHeight=itemHeight;
			for each (var o:Object in dataProvider)
			{
				var pb:PButton=selectable ? new PToggleButton(o.name, o.selected, o.required) : new PButton(o.name);
				buttons.push(pb);
				pb.addEventListener(MouseEvent.CLICK, onClick);
				pb.centerFill=true;
				layout.addItem(pb);
			}
		}

		protected function onClick(event:MouseEvent):void
		{
			dispatchEvent(new IndexEvent(buttons.indexOf(event.currentTarget)));
			if (selectable)
			{
				for each (var pb:PToggleButton in buttons)
				{
					if (pb != event.currentTarget)
						pb.selected=false;
				}
			}
		}

		override protected function dispose():void
		{
			for each (var pb:PToggleButton in buttons)
			{
				pb.removeEventListener(MouseEvent.CLICK, onClick);
			}
			buttons.length=0;
			buttons=null;
		}
	}
}
