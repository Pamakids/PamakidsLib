package com.pamakids.layouts
{
	import com.pamakids.components.base.Container;
	import com.pamakids.layouts.base.LayoutBase;

	import flash.display.DisplayObject;

	public class TileLayout extends LayoutBase
	{
		private var verticalGap:Number
		private var horizontalGap:Number
		private var numColumns:int

		public function TileLayout(numColumns:int, verticalGap:Number=0, horizontalGap:Number=0, container:Container=null)
		{
			super(container);
			this.numColumns=numColumns
			this.verticalGap=verticalGap
			this.horizontalGap=horizontalGap
		}

		override public function update():void
		{
			var totalHeight:Number=0
			var totalWidth:Number=0
			var item:DisplayObject
			var i:int, l:int=items.length
			for (i=0; i < l; i++)
			{
				item=items[i]
				item.x=(i % numColumns) * (horizontalGap + item.width)
				item.y=int(i / numColumns) * (verticalGap + item.height)
			}

			if (autoFill && l > 0)
			{
				contentHeight=(verticalGap + item.height) * Math.ceil(l / numColumns) - verticalGap
				contentWidth=(horizontalGap + item.width) * numColumns - horizontalGap

				//trace(contentWidth + ' | ' + contentHeight)
				container.setSize(contentWidth, contentHeight);
			}
		}
	}
}
