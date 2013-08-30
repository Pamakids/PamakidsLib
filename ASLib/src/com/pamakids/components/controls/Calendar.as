package com.pamakids.components.controls
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.pamakids.components.SkinnableDataContainer;
	import com.pamakids.components.base.Container;
	import com.pamakids.utils.DateUtil;

	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;


	/**
	 * css:
	 * * title
	 * * titleGroup
	 * @author mani
	 *
	 */
	public class Calendar extends SkinnableDataContainer
	{
		public static const BOOK_MODE:int=0;

		private var _month:int;
		public var today:Date;
		private var titleGroup:Container;
		private var title:Label;
		/**
		 * 默认只可选择今天之后的日期
		 */
		public var mode:int;

		public function Calendar(width:Number=0, height:Number=0, styleName:String='', enableBackground:Boolean=false)
		{
			backgroudAlpha=1;
			backgroundColor=0x000000;
			super(styleName, width, height, true, true);
		}

		public function get month():int
		{
			return _month;
		}

		public function set month(value:int):void
		{
			if (mode == BOOK_MODE)
			{
				if (value <= today.getMonth())
				{
					if (left)
						left.visible=false;
					value=today.getMonth();
				}
				else if (left)
				{
					left.visible=true;
				}
			}
			_month=value;
			if (title)
			{
				var d:Date=new Date();
				trace(d.month, today.month, value);
				d.month=value;
				trace(d.month, today.month, value);
				title.text=DateUtil.getNianYue(d);
				trace(value, d.getMonth(), title.text);
			}
		}

		override protected function init():void
		{
			if (!today)
				today=new Date();
			month=today.getMonth();
			updateSkin();
			initTitleGroup();
			super.init();
		}

		private function initTitleGroup():void
		{
			titleGroup=new Container(width, int(getStyle('titleGroup')['height']), true);
			titleGroup.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			titleGroup.addEventListener(MouseEvent.ROLL_OUT, outHandler);
			titleGroup.addEventListener(MouseEvent.CLICK, flipHandler);
			titleGroup.backgroudAlpha=1;
			titleGroup.backgroundColor=getColor('titleGroup');
			addChild(titleGroup);

			title=new Label(DateUtil.getNianYue(today), width);
			title.color=getColor('title');
			title.fontSize=getFontSize('title');
			title.y=8;
			titleGroup.addChild(title);
			left=getBitmap(styleName + 'Left');
			if (month == today.getMonth())
				left.visible=false;
			titleGroup.addChild(left);
			leftRightY=(title.height - left.height) / 2 + title.y;
			positionLeft();
			right=getBitmap(styleName + 'Right');
			titleGroup.addChild(right);
			positionRight();
		}

		protected function flipHandler(event:MouseEvent):void
		{
			var p:Point=new Point(event.stageX, event.stageY);
			p=globalToLocal(p);
			if (p.x > width / 2)
				month++;
			else if (left.visible)
				month--;
		}

		private var leftRightY:Number;

		protected function outHandler(event:MouseEvent):void
		{
			var p:Point=new Point(event.stageX, event.stageY);
			p=globalToLocal(p);
			if (p.x > width / 2)
				TweenLite.to(right, 0.3, {x: width - right.width - 10, y: leftRightY, ease: Cubic.easeIn});
			else
				TweenLite.to(left, 0.3, {x: 10, y: leftRightY, ease: Cubic.easeIn});
			Mouse.show();
		}

		protected function moveHandler(event:MouseEvent):void
		{
			Mouse.hide();
			var p:Point=new Point(event.stageX, event.stageY);
			p=globalToLocal(p);
			if (p.x > width / 2)
			{
				right.x=p.x - right.width / 2;
				right.y=p.y - right.height / 2;
				positionLeft();
			}
			else
			{
				if (left.visible)
				{
					left.x=p.x - left.width / 2;
					left.y=p.y - left.height / 2;
				}
				else
				{
					Mouse.show();
				}
				positionRight();
			}
		}

		private function positionLeft():void
		{
			left.x=10;
			left.y=leftRightY;
		}

		private function positionRight():void
		{
			right.x=width - right.width - 10;
			right.y=leftRightY;
		}

		private var left:Bitmap;
		private var right:Bitmap;

		override protected function updateSkin():void
		{
			super.updateSkin();
		}
	}
}
import com.pamakids.components.ItemRenderer;



class DateRender extends ItemRenderer
{
	override protected function renderData():void
	{
		super.renderData();
	}
}
