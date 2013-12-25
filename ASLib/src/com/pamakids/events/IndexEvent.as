package com.pamakids.events
{
	import flash.events.Event;

	/**
	 * 索引变换事件
	 * @author mani
	 */
	public class IndexEvent extends Event
	{
		public static const INDEX:String="INDEX";

		public var index:int;
		public var data:Object;

		public function IndexEvent(index:int, data:Object=null)
		{
			this.index=index;
			this.data=data;
			super("INDEX");
		}
	}
}
