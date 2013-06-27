package com.greensock.events
{
	import flash.events.Event;

	public class UserBehaviorEvent extends Event
	{
		public static const EVENT_ID:String="UserBehaviorEvent";

		public var category:String, action:String, label:String='', value:int=0;
		public var needCrtContent:Boolean=false;

		/**
		 * @param 交互点ID
		 * @param 交互点动作描述
		 * */
		public function UserBehaviorEvent(_category:String="defaultCat", _action:String="defaultAct")
		{
			super(EVENT_ID, true);
			category=_category;
			action=_action;
		}
	}
}
