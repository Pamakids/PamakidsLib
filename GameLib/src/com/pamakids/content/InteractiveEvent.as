package com.pamakids.content
{
	import flash.events.Event;

	public class InteractiveEvent extends Event
	{
		public static const INTERACTIVE:String="INTERACTIVE";

		/**
		 * 交互点ID
		 */
		public var id:String;

		/**
		 * 如果是动画，则需要记录动画播放的完成度，为方便记录需要转换为0-100的整数
		 */
		public var percent:int;

		public function InteractiveEvent(id:String, percent:int=100)
		{
			this.id=id;
			this.percent=percent;
			super(INTERACTIVE);
		}
	}
}
