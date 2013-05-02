package com.pamakids.game
{
	import flash.events.Event;

	public class GameEvent extends Event
	{
		public static const INITIALIZED:String="INITIALIZED";
		public static const GAME_OVER:String="GAME_OVER";
		public static const GAME_WRONG:String="GAME_WRONG";
		public static const GMAE_RIGHT:String="GMAE_RIGHT";

		public function GameEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
