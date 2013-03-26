package com.pamakids.layouts
{
	import com.pamakids.components.base.Container;
	import com.pamakids.layouts.base.LayoutBase;

	import flash.display.DisplayObject;

	public class HLayout extends LayoutBase
	{
		public var verticalCenter:Boolean=true; //为什么这里要写默认值 而下面的没呢?
		public var horizontalCenter:Boolean;

		public function HLayout(container:Container)
		{
			super(container);
		}

		override public function update():void
		{
			var x:Number=0;
			for each (var d:DisplayObject in items)
			{
				d.x=x + paddingLeft;
				if (verticalCenter && !autoFill)
					d.y=(height - d.height) / 2;
				x=x + d.width + gap;
			}
			if (autoFill)
			{
				if (d)
				{
					contentHeight=d.height;
					contentWidth=x + d.width;
				}
				container.setSize(contentWidth, contentHeight);
			}
		}
	}
}
