package com.pamakids.layouts.base
{
	import com.pamakids.components.base.Container;
	import com.pamakids.layouts.ILayout;

	import flash.display.DisplayObject;
	import flash.events.Event;

	public class LayoutBase implements ILayout
	{
		private var _gap:Number=0;
		public var paddingLeft:Number=0;
		public var paddingRight:Number=0;
		public var paddingTop:Number=0;
		public var paddingBottom:Number=0;
		private var _itemWidth:Number=0;
		private var _itemHeight:Number=0;
		protected var _container:Container;
		public var contentWidth:Number=0;
		public var contentHeight:Number=0;

		public static const HORIZONTAL:String="HORIZONTAL";
		public static const VERTICAL:String="VERTICAL";
		protected var items:Array=[];

		public function LayoutBase(container:Container=null)
		{
			if (container)
			{
				this.container=container;
				this.container.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			}
		}

		public function get container():Container
		{
			return _container;
		}

		public function set container(value:Container):void
		{
			_container=value;
			value.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}

		public function get gap():Number
		{
			return _gap;
		}

		public function set gap(value:Number):void
		{
			_gap=value;
			update();
		}

		protected function onRemove(event:Event):void
		{
			dispose();
		}

		public function get itemHeight():Number
		{
			return _itemHeight;
		}

		public function set itemHeight(value:Number):void
		{
			_itemHeight=value;
			measure();
		}

		public function get itemWidth():Number
		{
			return _itemWidth;
		}

		public function set itemWidth(value:Number):void
		{
			_itemWidth=value;
			measure();
		}

		public function addItem(displayObject:DisplayObject):void
		{
			if (itemWidth && itemHeight)
			{
				displayObject.width=itemWidth;
				displayObject.height=itemHeight;
			}
			items.push(displayObject);
			update();
		}

		public function dispose():void
		{
			container.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			container=null;
			items.length=0;
		}

		public function measure():void
		{
			if (!itemWidth || !itemHeight)
				return;

			for each (var d:DisplayObject in items)
			{
				d.width=itemWidth;
				d.height=itemHeight;
			}
			update();
		}

		public function removeItem(displayObject:DisplayObject):void
		{
			container.removeChild(displayObject);
			items.splice(items.indexOf(displayObject), 1);
			update();
		}

		public function update():void
		{

		}

		public function get height():Number
		{
			return container.height;
		}

		public function get width():Number
		{
			return container.width;
		}

		public function get autoFill():Boolean
		{
			return container.autoFill;
		}



	}
}
