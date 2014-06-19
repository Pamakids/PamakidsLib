package com.pamakids.services
{
	import flash.events.Event;

	public class BAUploadedEvent extends Event
	{
		public static const EVENT_ID:String='BAUploadedEvent';
		public var data:Object;

		public function BAUploadedEvent(_data:Object)
		{
			data=_data;
			super(EVENT_ID);
		}
	}
}

