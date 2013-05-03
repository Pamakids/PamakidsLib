package model.content
{
	import model.games.GameVO;

	public class EventsVO
	{
		public function EventsVO()
		{

		}
		/**
		 * 间隔时间
		 */
		public var intervalTime:Number;
		public var type:String;
		public var audioFile:String;
		public var subtitles:Array;
		/**
		 * 时间总时间
		 */
		public var totalTime:Number;
		public var gameVO:GameVO;
		/**
		 * 依赖于接受到互动内容派发的事件再播放，不为空则需要等待互动内容派发事件
		 */
		public var dependOn:String;
		/**
		 * 是否重复播放声音
		 */
		public var repeat:Boolean;
		/**
		 * 互动内容状态列表
		 */
		public var states:Array;
		/**
		 * 事件播放完成后显示下一页按钮
		 */
		public var showNextButton:Boolean;
	}
}
