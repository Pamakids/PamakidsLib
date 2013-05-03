package com.pamakids.content
{

	public class ContentStateVO
	{
		public var state:String;
		public var tip:String;

		/**
		 * 切换到该状态的时间，由编辑器里进行设定
		 */
		public var time:Number;

		public function ContentStateVO(state:String='', tip:String='')
		{
			this.state=state;
			this.tip=tip;
		}
	}
}
