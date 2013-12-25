package com.pamakids.helper
{
	import com.pamakids.components.base.Skin;

	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;

	/**
	 * 图片浏览助手
	 * @author mani
	 */
	public class ImageViewHelper extends Skin
	{
		public function ImageViewHelper(width:Number=0, height:Number=0)
		{
			super('imageViewHelper', width, height, true);
			updateSkin();
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
			addEventListener(MouseEvent.CLICK, clickedHandler);
		}

		protected function clickedHandler(event:MouseEvent):void
		{
			if (clickedCallback != null)
			{
				if (currentCursor == left)
					clickedCallback(-1)
				else if (currentCursor == right)
					clickedCallback(1);
				else
				{
//					zoomedOut=!zoomedOut;
//					clickedCallback(zoomedOut);
					clickedCallback.length ? clickedCallback(zoomedOut) : clickedCallback();
				}
			}
		}

		override protected function dispose():void
		{
			super.dispose();
			clickedCallback=null;
		}

		private var currentCursor:Bitmap;

		protected function mouseOutHandler(event:MouseEvent):void
		{
			if (currentCursor)
				currentCursor.visible=false;
			Mouse.show();
		}

		private var zoomedOut:Boolean=false;
		public var clickedCallback:Function;

		protected function mouseMoveHandler(event:MouseEvent):void
		{
			Mouse.hide();
			if (currentCursor)
				currentCursor.visible=false;
			if (event.localX < width / 3)
				currentCursor=left;
			else if (event.localX > width * 2 / 3)
				currentCursor=right;
			else
				currentCursor=zoomedOut ? zoomOut : zoomIn;
			if (!currentCursor)
			{
				trace('No Cursor');
				return;
			}
			if (!currentCursor.parent)
				addChild(currentCursor);
			currentCursor.visible=true;
			currentCursor.x=event.localX - currentCursor.width / 2;
			currentCursor.y=event.localY - currentCursor.height / 2;
		}

		private var left:Bitmap;
		private var right:Bitmap;
		private var zoomIn:Bitmap;
		private var zoomOut:Bitmap;

		override protected function updateSkin():void
		{
			left=getBitmap(styleName + 'Left');
			right=getBitmap(styleName + 'Right');
			zoomIn=getBitmap(styleName + 'ZoomIn');
			zoomOut=getBitmap(styleName + 'ZoomOut');
		}
	}
}
