package com.pamakids.layouts
{
	import com.pamakids.components.base.Container;
	import com.pamakids.layouts.base.LayoutBase;
	
	import flash.display.DisplayObject;
	
	public class Llayout extends LayoutBase
	{
		
		public var verticalCenter:Boolean = true;
		public var horizontalCenter:Boolean;
		public function Llayout(container:Container)
		{
			super(container);
		}
		
		override public function update():void
		{
			
			var y:Number = 0;
			for each (var d:DisplayObject in items)
			{
				d.y = y + paddingTop;
				if(verticalCenter && !autoFill)
					d.x = (width - d.width)/2;
				y = y + d.height + gap;
				
			}
			if(d)
			{
				contentWidth = d.width;
				contentHeight = y + d.height;
			}
			if(autoFill)
				container.setSize(contentWidth,contentHeight);
		}
		
		
	}
}