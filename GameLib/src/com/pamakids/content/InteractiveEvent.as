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

		public var value:int;

		public function InteractiveEvent(id:String, value:int=0)
		{
			this.id=id;
			this.value=value;
			super(INTERACTIVE);
		}
	}
}
