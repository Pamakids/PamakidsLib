package com.pamakids.layouts
{
	import com.pamakids.components.base.Container;
	import com.pamakids.layouts.base.LayoutBase;

	import flash.display.DisplayObject;

	public class HLayout extends LayoutBase
	{
		public var verticalCenter:Boolean=true; //为什么这里要写默认值 而下面的没呢?
		public var horizontalCenter:Boolean;

		public function HLayout(container:Container=null)
		{
			super(container);
		}

		override public function update():void
		{
			var x:Number=0;
			var tox:Number;
			var toy:Number;
			for each (var d:DisplayObject in items)
			{
				toy=d.y;
				tox=x + paddingLeft;
				if (verticalCenter && !autoFill)
					toy=(height - d.height) / 2;
				positionItem(d, tox, toy);
				x=x + d.width + gap;
			}
			if (autoFill)
			{
				if (d)
				{
					contentHeight=d.height;
					contentWidth=d.x + d.width;
				}
				container.setSize(contentWidth, contentHeight);
			}
		}
	}
}
