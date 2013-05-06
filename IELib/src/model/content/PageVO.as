package model.content
{

	public class PageVO extends HotPointVO
	{
		public function PageVO()
		{
			super();
		}

		/**
		 * 当前页互动内容状态列表
		 */
		public var states:Array;

		public var showNextButton:Boolean;
		/**
		 * 索引
		 */
		public var index:int;
	}
}
