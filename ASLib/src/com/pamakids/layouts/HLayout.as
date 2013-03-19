package com.pamakids.layouts
{
	import com.pamakids.components.base.Container;
	import com.pamakids.layouts.base.LayoutBase;

	import flash.display.DisplayObject;

	public class HLayout extends LayoutBase
	{
		public var verticalCenter:Boolean=true;
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
				trace(x);
			}
			if (d)
			{
				contentHeight=d.height;
				contentWidth=x + d.width;
			}
			if (autoFill)
				container.setSize(contentWidth, contentHeight);
		}
	}
}
