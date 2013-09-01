package com.pamakids.layouts
{
	import com.pamakids.layouts.base.LayoutBase;

	import flash.display.DisplayObject;

	public class HLayout extends LayoutBase
	{
		public var verticalCenter:Boolean=true; //为什么这里要写默认值 而下面的没呢?
		public var horizontalCenter:Boolean;

		public function HLayout(gap:int=0)
		{
			this.gap=gap;
		}

		override public function update():void
		{
			if (items.length)
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
				else if (horizontalCenter && d)
				{
					var cw:Number;
					cw=d.x + d.width;
					var sx:Number=width / 2 - cw / 2;
					for each (d in items)
					{
						d.x=sx;
						sx=sx + d.width + gap;
					}
				}
			}
			else if (autoFill)
			{
				container.setSize(0, 0);
			}

		}
	}
}
