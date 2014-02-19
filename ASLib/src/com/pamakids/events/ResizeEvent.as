package com.pamakids.events
{
	import flash.events.Event;

	/**
	 * 尺寸重置事件
	 * @author mani
	 */
	public class ResizeEvent extends Event
	{
		public static const RESIZE:String="resize";

		public var width:Number;
		public var height:Number;

		public function ResizeEvent(width:Number, height:Number)
		{
			this.width=width;
			this.height=height;
			super(RESIZE);
		}
	}
}
