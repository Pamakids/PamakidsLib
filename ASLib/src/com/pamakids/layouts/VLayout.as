package com.pamakids.layouts
{
	import com.greensock.TweenLite;
	import com.pamakids.layouts.base.LayoutBase;

	import flash.display.DisplayObject;

	/**
	 * 垂直布局
	 * @author mani
	 */
	public class VLayout extends LayoutBase
	{
		private var verticalCenter:Boolean;
		private var horizentalCenter:Boolean=true;

		public function VLayout(gap:int=0, forceAutoFill:Boolean=false)
		{
			this.gap=gap;
			this.forceAutoFill=forceAutoFill;
		}

		override public function update():void
		{
			var elementY:Number=0;
			var x:Number;
			var y:Number;
			for each (var element:DisplayObject in items)
			{
				elementReady=element.width && element.height;
				allReady=elementReady;
				if (elementReady)
				{
					y=elementY + paddingTop;
					if (horizentalCenter && width)
						x=(width - element.width) / 2;
					else
						TweenLite.delayedCall(1, function(element:DisplayObject):void
						{
							element.x=(width - element.width) / 2;
						}, [element], true);
					positionItem(element, x, y);
					elementY=elementY + element.height + gap;
					caculateMax(element);
				}
			}
			if (autoFill || forceAutoFill || !width)
			{
				if (allReady && element)
				{
					contentHeight=element.height + element.y + paddingBottom;
					contentWidth=maxElementWidth + paddingLeft + paddingRight;
					container.setSize(contentWidth, contentHeight);
				}
			}
		}
	}
}
