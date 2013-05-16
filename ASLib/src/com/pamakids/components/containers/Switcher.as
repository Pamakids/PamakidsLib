package com.pamakids.components.containers
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.pamakids.components.base.Container;
	import com.pamakids.components.base.Skin;
	import com.pamakids.components.controls.ButtonBar;
	import com.pamakids.events.ResizeEvent;
	import com.pamakids.layouts.HLayout;
	import com.pamakids.layouts.ILayout;
	import com.pamakids.utils.DPIUtil;
	import com.pamakids.vo.ButtonVO;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	[Event(name="clickItem", type="com.pamakids.events.IndexEvent")]
	public class Switcher extends Skin
	{
		private var container:Container;
		private var dpiScale:Number;

		public function Switcher(width:Number=0, height:Number=0, styleName:String='switcher')
		{
			container=new Container();
			container.forceAutoFill=true;
			addChild(container);
			backgroudAlpha=0;
			dpiScale=DPIUtil.getDPIScale();
			super(styleName, width, height, true);
		}

		private var isHorizontal:Boolean=true;

		public function get currentPage():int
		{
			return _currentPage;
		}

		public function set currentPage(value:int):void
		{
			_currentPage=value;
			if (pagesBar)
				pagesBar.selectedIndex(value);
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
		}

		override protected function init():void
		{
			for each (var o:Object in dataProvider)
			{
				var item:Object=new itemRendererClass();
				if (item.hasOwnProperty('data'))
					item.data=o;
				item.width=width;
				item.height=height;
				container.addChild(item as DisplayObject);
			}
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			updateSkin();
		}

		override protected function updateSkin():void
		{
			if (pagesBar)
			{
				pagesBar.removeEventListener(ResizeEvent.RESIZE, positionBar);
				removeChild(pagesBar);
			}

			if (dataProvider && dataProvider.length > 1)
			{
				var iconButtons:Array=[];
				for each (var o:Object in dataProvider)
				{
					var bvo:ButtonVO=new ButtonVO(styleName + 'Normal', styleName + 'Selected', true, true);
					iconButtons.push(bvo);
				}

				var sb:Bitmap=getBitmap(styleName + 'Selected');

				pagesBar=new ButtonBar(iconButtons);
				pagesBar.addEventListener(ResizeEvent.RESIZE, positionBar);
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

		protected function onMouseDown(event:MouseEvent):void
		{
			if (moving || !dataProvider || dataProvider.length == 1)
				return;
			moving=true;
			downValue=isHorizontal ? event.stageX : event.stageY;
			recordValue=isHorizontal ? container.x : container.y;

			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		private var moving:Boolean;

		protected function onMouseUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
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
					TweenLite.to(container, 0.8, {x: toValue, ease: Cubic.easeOut, onComplete: movingComplete});
				}
			}
		}

		private function movingComplete():void
		{
			moving=false;
		}

		private var _currentPage:int;
		private var pagesBar:ButtonBar;

		protected function onMouseMove(event:MouseEvent):void
		{
			if (isHorizontal)
				container.x=recordValue + (event.stageX - downValue) / dpiScale;
			else
				container.y=recordValue + (event.stageY - downValue) / dpiScale;
		}
	}
}
