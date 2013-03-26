package com.pamakids.components.controls
{
	import com.pamakids.components.base.Container;
	import com.pamakids.components.base.Skin;
	import com.pamakids.layouts.ILayout;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class Panel extends Skin
	{
		private var scrollBar:ScrollBar;

		private var layout:ILayout;
		public var layoutClass:Class;

		private var container:Container;
		private var downPoint:Point;

		public function Panel(styleName:String='', width:Number=0, height:Number=0)
		{
			super(styleName, width, height, true, true);

			container=new Container();
			super.addChild(container);
		}

		override protected function init():void
		{
			if (layoutClass)
				layout=new layoutClass(container);
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

		protected function mouseMoveHandler(event:MouseEvent):void
		{
			container.y=downPoint.y - event.stageY;
			scrollBar.scrollTo(-container.y);
		}

		protected function mouseUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		override protected function dispose():void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			super.dispose();
		}

		private function initScrollBar():void
		{
			if (!scrollBar)
			{
				scrollBar=new ScrollBar('scrollBar', 0, height);
				scrollBar.x=width - scrollBar.width;
				super.addChild(scrollBar);
			}
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			container.addChild(child);
			if (layout)
				layout.addItem(child);
			if (container.height > height)
			{
				initScrollBar();
				scrollBar.contentHeight=container.height;
			}
			return child;
		}

		override public function removeChild(child:DisplayObject):DisplayObject
		{
			if (layout)
				layout.removeItem(child);
			return container.removeChild(child);
		}

	}
}
