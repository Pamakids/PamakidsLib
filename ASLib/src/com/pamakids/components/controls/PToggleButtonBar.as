package com.pamakids.components.controls
{
	import com.pamakids.components.base.Container;
	import com.pamakids.events.IndexEvent;
//	import com.pamakids.layouts.HLayout;
	import com.pamakids.layouts.ILayout;
	import com.pamakids.layouts.Llayout;
	import com.pamakids.layouts.base.LayoutBase;
	
	import flash.events.MouseEvent;

	public class PToggleButtonBar extends Container
	{

		private var dataProvider:Array;
		private var layout:ILayout;
		public var gap:Number=8;
		public var itemWidth:Number;
		public var itemHeight:Number;
		private var buttons:Array=[];

		public function PToggleButtonBar(dataProvider:Array, direction:String=LayoutBase.HORIZONTAL, width:Number=0, height:Number=0)
		{
			super(width, height);
			this.dataProvider=dataProvider;

			if (direction == LayoutBase.HORIZONTAL)
				layout=new Llayout(this);
		}

		override protected function init():void
		{
			layout.gap=gap;
			layout.itemWidth=itemWidth;
			layout.itemHeight=itemHeight;
			for each (var o:Object in dataProvider)
			{
				var pb:PToggleButton=new PToggleButton(o.name, o.selected, o.required);
				buttons.push(pb);
				pb.addEventListener(MouseEvent.CLICK, onClick);
				pb.centerFill=true;
				layout.addItem(pb);
			}
		}

		protected function onClick(event:MouseEvent):void
		{
			dispatchEvent(new IndexEvent(buttons.indexOf(event.currentTarget)));
			for each (var pb:PToggleButton in buttons)
			{
				if (pb != event.currentTarget)
					pb.selected=false;
			}
		}

		override protected function dispose():void
		{
			for each (var pb:PToggleButton in buttons)
			{
				pb.removeEventListener(MouseEvent.CLICK, onClick);
			}
		}
	}
}
