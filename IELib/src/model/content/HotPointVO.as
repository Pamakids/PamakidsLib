package model.content
{

	[Bindable]
	public class HotPointVO
	{
		public function HotPointVO()
		{

		}
		public var content:String;
		public var hotAreas:Array;
		public var events:Array;
		public var time:Number;
		/**
		 * 强制暂停播放
		 */
		public var forcePause:Boolean=true;
		public var backgroundMusic:String;
		public var globalBackgroundMusicVolume:Number=1;
	}
}
