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

		/**
		 * X,Y一般为鼠标StageX,StageY
		 * @param life 命数
		 * @param fromX 效果起始点X
		 * @param fromY 效果起始点Y
		 * @param type
		 *
		 */
		public function LifeEvent(life:uint, fromX:Number, fromY:Number, type:String="GOT_LIFE")
		{
			this.life=life;
			super(type);
		}

		public var life:uint;
		public var fromX:Number;
		public var fromY:Number;
	}
}
