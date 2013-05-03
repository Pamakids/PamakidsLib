package com.pamakids.layouts
{
	import com.pamakids.components.base.Container;
	import com.pamakids.layouts.base.LayoutBase;

	import flash.display.DisplayObject;

	public class VLayout extends LayoutBase
	{
		private var verticalCenter:Boolean;
		private var horizentalCenter:Boolean=true;

		public function VLayout(container:Container=null)
		{
			super(container);
		}

		override public function update():void
		{
			var elementY:Number=0;
			var x:Number;
			var y:Number;
			var elementReady:Boolean;
			for each (var element:DisplayObject in items)
			{
				elementReady=element.width && element.height;
				if (elementReady)
				{
					y=elementY + paddingTop;
					if (horizentalCenter)
						x=(width - element.width) / 2;
					positionItem(element, x, y);
					elementY=elementY + element.height + gap;
				}
			}
			if (autoFill)
			{
				if (elementReady)
				{
					contentHeight=element.height + element.y;
					contentWidth=element.width;
					container.setSize(contentWidth, contentHeight);
				}
			}
		}
	}
}
