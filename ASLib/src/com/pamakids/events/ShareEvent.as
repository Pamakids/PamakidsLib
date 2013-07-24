package com.pamakids.events
{
	import flash.events.Event;

	public class ShareEvent extends Event
	{
		public static const EVENT_ID:String="ShareEventID";
		public var shareID:String;
		public var okCallBack:Function;
		public var cancelCallBack:Function;
		public var property:int;
		public var isDirect:Boolean;

		public function ShareEvent(_shareID:String, _property:int=0)
		{
			super(EVENT_ID, true);
			shareID=_shareID;
			property=_property;
		}
	}
}
