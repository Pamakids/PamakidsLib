package com.pamakids.events
{
	import flash.events.Event;

	/**
	 * ObjectData 事件，用以快速传递对象
	 * @author mani
	 */
	public class ODataEvent extends Event
	{
		public static const CONFIRM:String='confirm';
		public static const ODATA:String='odata';
		public static const ODATA2:String='odata2';
		public static const ADD_FILTER:String='addFilter';
		public static const REMOVE_FILTER:String='removeFilter';
		public static const SHOW_PAGE:String='showPage';
		public static const DATA_CHANGED:String='DATA_CHANGED';
		public static const DELETED:String='DELETED';
		public var data:Object;
		public var data2:Object;

		public function ODataEvent(data:Object, type:String='odata', bubbles:Boolean=false)
		{
			super(type, bubbles);
			this.data=data;
		}
	}
}


