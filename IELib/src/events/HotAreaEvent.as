package events
{
	import flash.events.Event;

	import model.content.HotAreaVO;

	public class HotAreaEvent extends Event
	{

		public var vo:HotAreaVO;

		public function HotAreaEvent(type:String)
		{
			super(type);
		}
	}
}

