package com.pamakids.content
{

	/**
	 * 事件VO，由内容派发出来的事件
	 * @author mani
	 */
	public class EventDataVO
	{
		public var data:String;
		public var tip:String;

		public function EventDataVO(data:String, tip:String='')
		{
			this.data=data;
			this.tip=tip;
		}
	}
}
