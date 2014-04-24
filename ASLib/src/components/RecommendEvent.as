package components
{
	import flash.events.Event;

	public class RecommendEvent extends Event
	{
		public var url:String;

		public function RecommendEvent(_url:String)
		{
			url=_url;
			super(RECOMMENDEVENT, true);
		}

		public static const RECOMMENDEVENT:String="RECOMMENDEVENT";
	}
}
