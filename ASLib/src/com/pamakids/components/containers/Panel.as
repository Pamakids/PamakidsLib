package com.pamakids.components.containers
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.pamakids.components.base.Container;
	import com.pamakids.components.base.Skin;
	import com.pamakids.components.controls.ScrollBar;
	import com.pamakids.events.ResizeEvent;
	import com.pamakids.layouts.ILayout;
	import com.pamakids.layouts.base.LayoutBase;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * 面板
	 * @author mani
	 */
	public class Panel extends Skin
	{
		private var scrollBar:ScrollBar;

		private var container:Container;
		private var downPoint:Point;

		public function Panel(styleName:String='', width:Number=0, height:Number=0)
		{
			container=new Container();
			container.forceAutoFill=true;
			container.addEventListener(ResizeEvent.RESIZE, containerResizeHandler);
			super(styleName, width, height, true, true);
			super.addChild(container);
		}

		protected function containerResizeHandler(event:Event):void
		{
			updateScrollBar();
		}

		override protected function init():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}

		protected function mouseDownHandler(event:MouseEvent):void
		{
			if (container.height < height)
				return;
			downPoint=new Point(event.stageX, event.stageY);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		private var contentPostion:Number=0;
		private var friction:Number=0;
		public var direction:String=LayoutBase.VERTICAL;
		private var softDistance:Number=0;
		private var preMoveValue:Number=0;

		protected function mouseMoveHandler(event:MouseEvent):void
		{
			var isVertical:Boolean=direction == LayoutBase.VERTICAL;
			var dis:Number=isVertical ? downPoint.y - event.stageY : downPoint.x - event.stageX;
			var moveDistance:Number=dis / dpiScale;
			friction=Math.abs(moveDistance / height);
			var toValue:Number=contentPostion - moveDistance * (1 - friction);
			container.y=toValue;
			scrollBar.scrollTo(-toValue);

			softDistance=isVertical ? event.stageY - preMoveValue : event.stageX - preMoveValue;
			preMoveValue=isVertical ? event.stageY : event.stageX;
		}

		/**
		 * 自动缓动值
		 */
		private const TWEEN_FRICTION:Number=8;

		protected function mouseUpHandler(event:MouseEvent):void
		{
			if (container.y > 0)
			{
				if (scrollBar)
					scrollBar.restore();
				TweenLite.to(container, 0.5, {y: 0, ease: Cubic.easeOut});
				contentPostion=0;
			}
			else if (Math.abs(container.y) > container.height - height)
			{
				if (scrollBar)
					scrollBar.restore();
				TweenLite.to(container, 0.5, {y: height - container.height, ease: Cubic.easeOut});
				contentPostion=height - container.height;
			}
			else
			{
				contentPostion=container.y;
				var toValue:Number=contentPostion + softDistance * TWEEN_FRICTION;
				if (toValue > 0)
					toValue=0;
				else if (toValue < height - container.height)
					toValue=height - container.height;
				TweenLite.to(container, 0.5, {y: toValue, ease: Cubic.easeOut, onUpdate: function():void
				{
					contentPostion=container.y;
					if (scrollBar)
						scrollBar.scrollTo(-contentPostion);
				}});
			}
			removeStageListener();
		}

		override protected function dispose():void
		{
			removeStageListener();
			container.removeEventListener(ResizeEvent.RESIZE, containerResizeHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			super.dispose();
		}

		private function removeStageListener():void
		{
			if (stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			}
		}

		private function initScrollBar():void
		{
			if (!scrollBar)
			{
				scrollBar=new ScrollBar('scrollBar', 0, height);
				scrollBar.x=width - scrollBar.width - scrollBarOffset;
				super.addChild(scrollBar);
			}
		}

		/**
		 * 滚动条位置偏移量
		 */
		public var scrollBarOffset:Number=0;

		override public function set layout(value:ILayout):void
		{
			container.layout=value;
			value.width=width;
			value.height=height;
		}

		override protected function resize():void
		{
			super.resize();
			updateScrollBar();
		}

		private function updateScrollBar():void
		{
			if (container.height > height)
			{
				initScrollBar();
				scrollBar.contentHeight=container.height;
			}
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			container.addChild(child);
			updateScrollBar();
			return child;
		}
	}
}
