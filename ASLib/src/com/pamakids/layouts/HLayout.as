package com.pamakids.layouts
{
	import com.greensock.TweenLite;
	import com.pamakids.layouts.base.LayoutBase;

	import flash.display.DisplayObject;

	public class HLayout extends LayoutBase
	{
		public var verticalCenter:Boolean=true;
		public var horizontalCenter:Boolean;

		public function HLayout(gap:int=0)
		{
			this.gap=gap;
		}

		override public function update():void
		{
			var elementX:Number=0;
			var x:Number;
			var y:Number;
			for each (var element:DisplayObject in items)
			{
				elementReady=element.width && element.height;
				allReady=elementReady;
				if (elementReady)
				{
					x=elementX + paddingLeft;
					if (verticalCenter && height)
						y=(height - element.height) / 2;
					else
						TweenLite.delayedCall(1, function(element:DisplayObject):void {
							element.y=(height - element.height) / 2;
						}, [element], true);
					positionItem(element, x, y);
					elementX=elementX + element.width + gap;
					caculateMax(element);
				}
			}
			if (autoFill || forceAutoFill || !height)
			{
				if (allReady)
				{
					contentHeight=maxElementHeight + paddingBottom + paddingTop;
					contentWidth=element.x + element.width + paddingRight;
					container.setSize(contentWidth, contentHeight);
				}
			}

		}
	}
}
