package com.pamakids.components.controls
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.pamakids.components.ItemRenderer;
	import com.pamakids.components.SkinnableDataContainer;
	import com.pamakids.components.base.Container;
	import com.pamakids.events.ResizeEvent;
	import com.pamakids.layouts.HLayout;
	import com.pamakids.layouts.TileLayout;
	import com.pamakids.layouts.VLayout;
	import com.pamakids.utils.DateUtil;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
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
	[Event(name="change", type="flash.events.Event")]
	public class Calendar extends SkinnableDataContainer
	{
		public static const BOOK_MODE:int=0;

		public function Calendar(width:Number=0, height:Number=0, styleName:String='', enableBackground:Boolean=false)
		{
			super(styleName, width, height, true);
			backgroudAlpha=1;
			backgroundColor=getColor('backgroundColor');
			labelFunction=function(d:Date):String
			{
				return d ? d.date.toString() : '';
			}
		}

		public var maxBookMonthes:int;
		/**
		 * 默认使用预定模式
		 */
		public var mode:int;
		public var today:Date;

		protected var weeks:Array=['周日', '周一', '周二', '周三', '周四', '周五', '周六'];

		private var _month:int;
		private var left:Bitmap;
		private var leftRightY:Number;
		private var right:Bitmap;
		private var title:Label;
		private var titleGroup:Container;
		private var weekGroup:Container;

		/**
		 * 已预定的不可选择的日期
		 */
		public function get booked():Array
		{
			return _booked;
		}

		/**
		 * @private
		 */
		public function set booked(value:Array):void
		{
			_booked=value;
			renderData();
		}

		/**
		 * 已入住的不可选择的日期
		 */
		public function get checkedIn():Array
		{
			return _checkedIn;
		}

		/**
		 * @private
		 */
		public function set checkedIn(value:Array):void
		{
			_checkedIn=value;
			renderData();
		}

		public function get month():int
		{
			return _month;
		}

		public function set month(value:int):void
		{
			var d:Date=new Date(today.fullYear, today.month);
			d.month=value;
			var dp:Array=DateUtil.getDateData(d);
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
				if (maxBookMonthes && value - today.month > maxBookMonthes)
					return;
				var dd:Date;
				var i:int;
				endLoop: for each (d in dp)
				{
					i=0;
					for (i; i < selectedDates.length; i++)
					{
						dd=selectedDates[i];
						if (DateUtil.dateIsEqual(dd, d))
						{
							selectedDates[i]=d;
							continue endLoop;
						}
					}
					if (booked)
					{
						i=0;
						for (i; i < booked.length; i++)
						{
							dd=booked[i];
							if (DateUtil.dateIsEqual(d, dd))
							{
								booked[i]=d;
								continue endLoop;
							}
						}
					}
					if (checkedIn)
					{
						i=0;
						for (i; i < checkedIn.length; i++)
						{
							dd=checkedIn[i];
							if (DateUtil.dateIsEqual(d, dd))
							{
								checkedIn[i]=d;
								continue endLoop;
							}
						}
					}
				}
			}
			if (title)
				title.text=DateUtil.getNianYue(d);
			dataProvider=dp;
			_month=value;
		}

		private var _booked:Array;
		private var _checkedIn:Array;
		private var borderLine:Sprite;

		override public function updateRenderer(renderer:ItemRenderer, itemIndex:int, data:Object):void
		{
			super.updateRenderer(renderer, itemIndex, data);
			var id:Date=data as Date;
			var rd:DateRender=renderer as DateRender;
			if (id && id.time < today.time && !DateUtil.dateIsEqual(id, today))
				renderer.enabled=false;
			else if (selectedDates.indexOf(data) != -1)
				renderer.selected=true;
			else if (!rd.updateStatus(booked, checkedIn) && DateUtil.dateIsEqual(id, today))
				rd.isToday=true;
			if (!renderer.hasEventListener(Event.CHANGE))
				renderer.addEventListener(Event.CHANGE, changedHandler);
		}

		public var selectedDates:Array=[];

		private var checkIn:Date;
		private var checkOut:Date;

		protected function changedHandler(event:Event):void
		{
			var dr:DateRender=event.currentTarget as DateRender;
			if (dr.selected)
				selectedDates.push(dr.data);
			else if (selectedDates.indexOf(dr.data) != -1)
				selectedDates.splice(selectedDates.indexOf(dr.data), 1);
			trace(dr.selected, selectedDates);
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

		override protected function init():void
		{
			if (!today)
				today=new Date();
			month=today.getMonth();
			updateSkin();
			initTitleGroup();
			initDateGroup();
			initInfoGroup();
			lineColor=getColor('titleGroup');
			super.init();
		}

		private function initInfoGroup():void
		{
			var info:Container=new Container();
			info.forceAutoFill=true;
			info.layout=new HLayout(5);
			var checked:Container=new Container(13, 13, true);
			checked.backgroundColor=getColor('checked_in', 'DateRender');
			checked.backgroudAlpha=1;
			info.addChild(checked);
			var l:Label=new Label('已入住');
			info.addChild(l);
			var booked:Container=new Container(13, 13, true);
			booked.backgroundColor=getColor('booked', 'DateRender')
			booked.backgroudAlpha=1;
			info.addChild(booked);
			l=new Label('已预定');
			info.addChild(l);
			var selected:Container=new Container(13, 13, true);
			selected.backgroundColor=getColor('selectedBackgroundColor', 'DateRender');
			selected.backgroudAlpha=1;
			info.addChild(selected);
			l=new Label('已选择');
			info.addChild(l);
			addChild(info);
		}

		private function initDateGroup():void
		{
			container=new Container();
			container.addEventListener(ResizeEvent.RESIZE, contaierResizedHandler);
			addChild(container);
			layout=new VLayout(10, true);
			layout.paddingBottom=10;
			layout.gap=10;
			contentLayout=new TileLayout(7, 2, 2);
			itemRender=DateRender;
		}

		protected function contaierResizedHandler(event:Event):void
		{
			trace(container.width, container.height, Math.random());
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

		override protected function renderData():void
		{
			super.renderData();
		}

		override protected function updateSkin():void
		{
			super.updateSkin();
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

			var line:Sprite=new Sprite();
			line.mouseEnabled=line.mouseChildren=false;
			line.graphics.lineStyle(1, getColor('line'));
			line.graphics.moveTo(0, title.y + title.height + 8);
			line.graphics.lineTo(width, title.y + title.height + 8);
			titleGroup.addChild(line);

			weekGroup=new Container(width - 20);
			weekGroup.mouseEnabled=weekGroup.mouseChildren=false;
			weekGroup.forceAutoFill=true;
			weekGroup.x=10;
			weekGroup.y=title.y + title.height + 14;
			var h:HLayout=new HLayout();
			h.gap=5;
			weekGroup.layout=h;
			titleGroup.addChild(weekGroup);

			for each (var week:String in weeks)
			{
				var l:Label=new Label(week);
				l.color=getColor('week');
				l.fontSize=getFontSize('week');
				weekGroup.addChild(l);
			}
			titleGroup.height=weekGroup.y + l.height + 5;

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
	}
}

import com.pamakids.components.ItemRenderer;
import com.pamakids.components.controls.Label;
import com.pamakids.events.ResizeEvent;

class DateRender extends ItemRenderer
{
	public function DateRender()
	{
		super(30, 30, true);
	}

	public var isToday:Boolean;

	override public function set selected(value:Boolean):void
	{
		if (!data)
			return;
		super.selected=value;
		if (labelDisplay)
			labelDisplay.color=value ? getColor('selectedFontColor') : getColor();
		if (value)
		{
			backgroudAlpha=1;
			backgroundColor=getColor('selectedBackgroundColor');
		}
		else if (isToday)
		{
			backgroundColor=getColor('todayBackgroundColor');
		}
		else
		{
			backgroudAlpha=0;
		}
	}

	public function updateStatus(booked:Array, checkedIn:Array):Boolean
	{
		var b:Boolean;
		if (booked && booked.indexOf(data) != -1)
		{
			b=true;
			backgroudAlpha=1;
			backgroundColor=getColor('booked');
		}
		else if (checkedIn && checkedIn.indexOf(data) != -1)
		{
			b=true;
			backgroudAlpha=1;
			backgroundColor=getColor('checked_in');
			trace(data, 'ci', isToday);
		}
		mouseChildren=mouseEnabled=!b;
		return b;
	}

	protected function labelResizedHandler(event:ResizeEvent):void
	{
		centerDisplayObject(labelDisplay);
	}

	override protected function renderData():void
	{
		if (inited)
		{
			if (label && !labelDisplay)
			{
				labelDisplay=new Label(label);
				if (getFontSize())
					labelDisplay.fontSize=getFontSize();
				if (getColor())
					labelDisplay.color=selected ? getColor('selectedFontColor') : getColor();
				labelDisplay.addEventListener(ResizeEvent.RESIZE, labelResizedHandler);
				addChild(labelDisplay);
			}
			else if (labelDisplay)
			{
				labelDisplay.text=label;
			}
			if (isToday)
			{
				backgroudAlpha=1;
				backgroundColor=getColor('todayBackgroundColor');
			}
		}
	}
}
