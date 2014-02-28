package com.pamakids.components
{
	import com.pamakids.components.base.Container;
	import com.pamakids.components.controls.ScrollBar;
	import com.pamakids.events.ResizeEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class List extends SkinnableDataContainer
	{
		public function List(width:Number=0, height:Number=0, styleName:String='', enableBackground:Boolean=false)
		{
			container = new Container();
			container.forceAutoFill=true;
			container.addEventListener(ResizeEvent.RESIZE, containerResizedHandler);
			super(styleName, width, height, enableBackground, true);
		}
		
		protected function containerResizedHandler(event:Event):void
		{
			if(container.height > height)
			{
				initScrollBar();
				scrollBar.contentHeight = container.height;
			}
		}
		
		/**
		 * 滚动条位置偏移量
		 */
		public var scrollBarOffset:Number=0;
		
		private function initScrollBar():void
		{
			if(!scrollBar)
			{
				scrollBar = new ScrollBar('scrollBar', 0, height);
				scrollBar.x = width-scrollBar.width - scrollBarOffset;
				super.addChild(scrollBar);
			}
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			return container.addChild(child);
		}
		
		public var useVirtualLayout:Boolean;
		
		public var itemWidth:Number;
		public var itemHeight:Number;
		private var scrollBar:ScrollBar;
		
		override protected function init():void
		{
			super.init();
		}
		
		override public function updateRenderer(renderer:ItemRenderer, itemIndex:int, data:Object):void
		{
			if(itemWidth)
				renderer.width = itemWidth;
			else
				itemWidth = renderer.width;
			
			if(itemHeight)
				renderer.height = itemHeight;
			else
			 	itemHeight = renderer.height;
			
			super.updateRenderer(renderer, itemIndex, data);
		}
	}
}