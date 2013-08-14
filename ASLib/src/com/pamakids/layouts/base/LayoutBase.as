package com.pamakids.layouts.base
{
	import com.greensock.TweenLite;
	import com.pamakids.components.base.Container;
	import com.pamakids.events.ResizeEvent;
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
				this.container=container;
		}

		private var _useVirtualLayout:Boolean;

		public function get useVirtualLayout():Boolean
		{
			return _useVirtualLayout;
		}

		public function set useVirtualLayout(value:Boolean):void
		{
			if (_useVirtualLayout && value)
				clearVirtualLayoutCache();
			_useVirtualLayout=value;
		}

		public function clearVirtualLayoutCache():void
		{
		}

		public function get height():Number
		{
			return _height ? _height : container.height;
		}

		public function set height(value:Number):void
		{
			_height=value;
		}

		public function get width():Number
		{
			return _width ? _width : container.width;
		}

		public function set width(value:Number):void
		{
			_width=value;
		}

		public function get container():Container
		{
			return _container;
		}

		public function set container(value:Container):void
		{
			_container=value;
			if (value)
				value.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}

		public function get gap():Number
		{
			return _gap;
		}

		public function set gap(value:Number):void
		{
			_gap=value;
			if (container)
				delayUpdate();
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
			if (displayObject.width && displayObject.height)
			{
				delayUpdate();
			}
			else
			{
				displayObject.addEventListener(Event.COMPLETE, itemCompleHandler);
				displayObject.addEventListener(ResizeEvent.RESIZE, itemResizedHandler);
			}
			displayObject.visible=false;
		}

		protected function itemResizedHandler(event:Event):void
		{
			delayUpdate();
		}

		protected function itemCompleHandler(event:Event):void
		{
			trace('itemCompleted');
			delayUpdate();
		}

		public function dispose():void
		{
			container.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			container=null;
			for each (var displayObject:DisplayObject in items)
			{
				if (displayObject.hasEventListener(Event.COMPLETE))
					displayObject.removeEventListener(Event.COMPLETE, itemCompleHandler);
				if (displayObject.hasEventListener(ResizeEvent.RESIZE))
					displayObject.removeEventListener(ResizeEvent.RESIZE, itemResizedHandler);
			}
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
			delayUpdate();
		}

		public function removeItem(displayObject:DisplayObject):void
		{
			if (displayObject.hasEventListener(Event.COMPLETE))
				displayObject.removeEventListener(Event.COMPLETE, itemCompleHandler);
			if (displayObject.hasEventListener(ResizeEvent.RESIZE))
				displayObject.removeEventListener(ResizeEvent.RESIZE, itemResizedHandler);
			container.removeChild(displayObject);
			items.splice(items.indexOf(displayObject), 1);
			delayUpdate();
		}

		private function delayUpdate():void
		{
//			update();
			TweenLite.killDelayedCallsTo(update);
			TweenLite.delayedCall(0.1, update);
		}

		public function update():void
		{

		}

		private var tweenX:Boolean=true;
		private var tweenY:Boolean=true;
		private var animationVars:Object;
		private var duration:Number;

		/**
		 * 设置缓动对象
		 * @param tween
		 * @param tweenX 是否缓动X
		 * @param tweenY 是否缓动Y
		 */
		public function setAnimation(duration:Number, vars:Object, tweenX:Boolean=true, tweenY:Boolean=true):void
		{
			this.tweenX=tweenX;
			this.tweenY=tweenY;
			animationVars=vars;
			this.duration=duration;
		}

		protected function positionItem(target:DisplayObject, x:Number, y:Number):void
		{
			if (animationVars)
			{
				var vars:Object={};
				for (var p:String in animationVars)
				{
					vars[p]=animationVars[p];
				}
				if (!tweenX)
					target.x=x;
				else
					vars.x=x;
				if (!tweenY)
					target.y=y;
				else
					vars.y=y;
				if (tweenX || tweenY)
					TweenLite.to(target, duration, vars);
			}
			else
			{
				target.x=x;
				target.y=y;
			}
			target.visible=true;
		}

		private var _width:Number;
		private var _height:Number;

		public function get autoFill():Boolean
		{
			return container.autoFill;
		}

	}
}
