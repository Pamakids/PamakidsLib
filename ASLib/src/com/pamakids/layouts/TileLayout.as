package com.pamakids.layouts
{
	import com.pamakids.components.base.Container;
	import com.pamakids.layouts.base.LayoutBase;

	import flash.display.DisplayObject;

	public class TileLayout extends LayoutBase
	{
		private var verticalGap:Number=0
		private var horizontalGap:Number=0

		public function TileLayout(container:Container=null)
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
