package model.content
{

	/**
	 * 影片VO，包含所有交互数据信息
	 * @author mani
	 */
	[Bindable]
	public class VideoVO extends DataBaseVO
	{
		public function VideoVO()
		{

		}
		/**
		 * 影片相对地址
		 */
		public var url:String;
		/**
		 * 影片封面
		 */
		public var cover:String;
		/**
		 * 播放次数
		 */
		public var playTimes:int;

		/**
		 * 热点数组
		 */
		public var hotPoints:Array;

		public var dir:String;

	}
}

