package com.pamakids.events
{
	import flash.events.Event;

	public class RollawayEvent extends Event
	{
		public function RollawayEvent(type:String, offset:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.offset=offset
		}



		public static const ROLL_RELEASE:String='rollRelease'


		public var offset:Number

	}
}
