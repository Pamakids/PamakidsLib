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

		/**
		 * 警告
		 */
		public var rightAlert:String;
		public var wrongAlert:String;
		public var successAlert:String;
		public var failuredAlert:String;
		public var thumbnail:String;

		public function isSwf():Boolean
		{
			return content ? content.indexOf('.swf') != -1 : false;
		}
	}
}
