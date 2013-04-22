package
{

	/**
	 * 事件VO，由内容派发出来的事件
	 * @author mani
	 */
	public class EventVO
	{
		public var type:String;
		public var tip:String;

		public function EventVO(type:String='', tip:String='')
		{
			this.type=type;
			this.tip=tip;
		}
	}
}
