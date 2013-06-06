package com.pamakids.content
{
	import flash.events.Event;

	/**
	 * 生命增减事件
	 * @author mani
	 */
	public class LifeEvent extends Event
	{
		public static const GOT_LIFE:String="GOT_LIFE";
		public static const LOSE_LIFE:String="LOSE_LIFE";

		public function LifeEvent(life:uint, type:String="GOT_LIFE")
		{
			this.life=life;
			super(type);
		}

		public var life:uint;
	}
}
