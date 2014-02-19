package com.pamakids.layouts
{
	import com.pamakids.layouts.base.LayoutBase;

	import flash.display.DisplayObject;

	/**
	 * 铺格布局
	 * @author mani
	 */
	public class TileLayout extends LayoutBase
	{
		private var verticalGap:Number
		private var horizontalGap:Number
		private var numColumns:int
		private var horizentalCenter:Boolean=true;

		public function TileLayout(numColumns:int, verticalGap:Number=0, horizontalGap:Number=0)
		{
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
			var x:Number;
			var y:Number;
			var xoffset:Number=0;
			for (i=0; i < l; i++)
			{
				item=items[i];
				if (horizentalCenter && !xoffset && width && !container.forceAutoFill)
					xoffset=(width - (item.width * numColumns) - horizontalGap * (numColumns - 1)) / 2;
				x=xoffset + (i % numColumns) * (horizontalGap + item.width);
				y=int(i / numColumns) * (verticalGap + item.height);
				positionItem(item, x, y);
			}

			if (autoFill && l > 0)
			{
				contentHeight=(verticalGap + item.height) * Math.ceil(l / numColumns) - verticalGap;
				contentWidth=(horizontalGap + item.width) * numColumns - horizontalGap;
				container.setSize(contentWidth, contentHeight);
			}
		}
	}
}
