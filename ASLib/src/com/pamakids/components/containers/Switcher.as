package com.pamakids.components.containers
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.pamakids.components.base.Container;
	import com.pamakids.components.base.Skin;
	import com.pamakids.components.controls.ButtonBar;
	import com.pamakids.events.IndexEvent;
	import com.pamakids.events.ResizeEvent;
	import com.pamakids.layouts.HLayout;
	import com.pamakids.layouts.ILayout;
	import com.pamakids.vo.ButtonVO;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	[Event(name="clickItem", type="com.pamakids.events.IndexEvent")]
	[Event(name="moved", type="flash.events.Event")]

	/**
	 * 幻灯片
	 */
	public class Switcher extends Skin
	{
		private var container:Container;
		/**
		 * 禁用拖拽，主要用于网页
		 */
		public var disableDrag:Boolean;

		public function Switcher(width:Number=0, height:Number=0, styleName:String='switcher')
		{
			container=new Container();
			container.forceAutoFill=true;
			addChild(container);
			backgroudAlpha=0;
			super(styleName, width, height, true, true);
			maskTarget=container;
			drawMask();
		}

		private var isHorizontal:Boolean=true;

		public function get currentPage():int
		{
			return _currentPage;
		}

		public function set currentPage(value:int):void
		{
			if (value < 0)
				value=0;
			else if (value >= dataProvider.length)
				value=dataProvider.length - 1;
			_currentPage=value;
			if (!disableDrag || pagesBar)
				pagesBar.selectedIndex(value);
			if (disableDrag)
				TweenLite.to(container, 0.3, {x: -currentPage * width, ease: Cubic.easeOut, onComplete: movingComplete});
		}

		override public function set layout(value:ILayout):void
		{
			isHorizontal=value is HLayout;
			container.layout=value;
			value.width=width;
			value.height=height;
		}

		private var _dataProvider:Array;
		public var itemRendererClass:Class;

		public function get dataProvider():Array
		{
			return _dataProvider;
		}

		public function set dataProvider(value:Array):void
		{
			_dataProvider=value;
			if (inited)
				fillData();
		}

		override protected function init():void
		{
			super.init();
			if (!itemRendererClass)
			{
				throw new Error('ItemRendererClass can not be null');
				return;
			}
			if (!layout)
			{
				var h:HLayout=new HLayout();
				h.width=width;
				h.height=height;
				container.layout=h;
			}
			fillData();
			if (!disableDrag)
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		private function fillData():void
		{
			if (!dataProvider)
				return;
			while (container.numChildren)
				container.removeChildAt(0);
			for each (var o:Object in dataProvider)
			{
				var item:Object=new itemRendererClass();
				if (item.hasOwnProperty('data'))
					item.data=o;
				item.width=width;
				item.height=height;
				container.addChild(item as DisplayObject);
			}
			_currentPage=0;
			container.x=0;
			updateSkin();
		}

		public function get currentItem():Object
		{
			return container.getChildAt(currentPage);
		}

		override protected function updateSkin():void
		{
			if (pagesBar)
			{
				pagesBar.removeEventListener(ResizeEvent.RESIZE, positionBar);
				removeChild(pagesBar);
			}

			var sb:Bitmap=getBitmap(styleName + 'Selected');

			if (dataProvider && dataProvider.length > 1 && sb)
			{
				var iconButtons:Array=[];
				for each (var o:Object in dataProvider)
				{
					var bvo:ButtonVO=new ButtonVO(styleName + 'Normal', styleName + 'Selected', true, true);
					iconButtons.push(bvo);
				}

				if (showPageIcon)
				{
					pagesBar=new ButtonBar(iconButtons);
					pagesBar.addEventListener(ResizeEvent.RESIZE, positionBar);
					pagesBar.addEventListener(IndexEvent.INDEX, indexChangedHandler);
					pagesBar.forceAutoFill=true;
					pagesBar.gap=8;
					pagesBar.itemWidth=sb.width;
					pagesBar.itemHeight=sb.height;
					pagesBar.y=height + pagesBarOffset;
					addChild(pagesBar);
					sb.bitmapData.dispose();
					pagesBar.selectedIndex(currentPage);
				}
			}
		}

		protected function indexChangedHandler(event:IndexEvent):void
		{
			currentPage=event.index;
		}

		public var showPageIcon:Boolean=true;

		protected function positionBar(event:ResizeEvent):void
		{
			pagesBar.x=width / 2 - pagesBar.width / 2;
		}

		/**
		 * 页码组偏移值
		 */
		public var pagesBarOffset:Number=-8;
		private var downValue:Number;
		private var recordValue:Number;
		public var disableInterval:int;
		private var downTime:int;

		protected function onMouseDown(event:MouseEvent):void
		{
			if (!dataProvider || dataProvider.length == 1)
				return;
			if (disableInterval && getTimer() - downTime < disableInterval)
				return;
			downTime=getTimer();
			downValue=isHorizontal ? event.stageX : event.stageY;
			recordValue=isHorizontal ? container.x : container.y;

			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		override protected function dispose():void
		{
			super.dispose();
			if (stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
		}

		protected function onMouseUp(event:MouseEvent):void
		{
			if (stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			var toValue:Number;
			var next:Boolean=event.stageX - downValue > 0;

			if (isHorizontal)
			{
				if (Math.abs(event.stageX - downValue) < 58 || (!next && currentPage == dataProvider.length - 1) || (next && !currentPage))
				{
					toValue=recordValue;
					TweenLite.to(container, 0.3, {x: toValue, ease: Cubic.easeOut, onComplete: movingComplete});
				}
				else
				{
					currentPage=next ? currentPage - 1 : currentPage + 1;
					toValue=-currentPage * width;
					TweenLite.to(container, 0.3, {x: toValue, ease: Cubic.easeOut, onUpdate: updateMove, onComplete: movingComplete});
				}
			}
		}

		private function updateMove():void
		{
			if (isHorizontal)
				recordValue=container.x;
			else
				recordValue=container.y;
		}

		public function get selectedItem():Object
		{
			return dataProvider[currentPage];
		}

		private function movingComplete():void
		{
			dispatchEvent(new Event('moved'));
		}

		private var _currentPage:int;
		public var pagesBar:ButtonBar;

		protected function onMouseMove(event:MouseEvent):void
		{
			if (isHorizontal)
				container.x=recordValue + (event.stageX - downValue) / dpiScale;
			else
				container.y=recordValue + (event.stageY - downValue) / dpiScale;
		}
	}
}
