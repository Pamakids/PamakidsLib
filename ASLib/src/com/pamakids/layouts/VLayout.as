package com.pamakids.layouts
{
	import com.pamakids.components.base.Container;
	import com.pamakids.layouts.base.LayoutBase;

	import flash.display.DisplayObject;

	public class VLayout extends LayoutBase
	{
		private var verticalCenter:Boolean;
		private var horizentalCenter:Boolean=true;

		public function VLayout(container:Container)
		{
			super(container);
		}

		override public function update():void
		{
			var elementY:Number=0;
			for each (var element:DisplayObject in items)
			{
				element.y=elementY + paddingTop;
				if (horizentalCenter && !autoFill)
					element.x=(width - element.width) / 2;
				elementY=elementY + element.height + gap;
			}
			if (autoFill)
			{
				if (element)
				{
					contentHeight=element.height + element.y;
					contentWidth=element.width;
				}
				container.setSize(contentWidth, contentHeight);
			}
		}
	}
}
