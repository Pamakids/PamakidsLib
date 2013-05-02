package model.content
{

	[Bindable]
	public class ConversationVO extends SubtitleVO
	{
		public function ConversationVO()
		{
			showPosition='';
		}

		public var avatar:String;
		public var avatarStartX:Number=0;
		public var avatarStartY:Number=0;
		public var avatarX:Number=0;
		public var avatarY:Number=0;
		public var subtitleX:Number=0;
		public var subtitleY:Number=0;
		/**
		 * 缩放倍数，不同DPI进行不同的放大缩小
		 */
		public var avatarScale:Number=1;
		public var subtitleScale:Number=1;
		public var fadeIn:Boolean;
		/**
		 * 效果参数
		 */
		public var effectData:Object;

		/**
		 * 类型，显示提示用，包括成功、出错、失败的提示
		 */
		public var type:String;
		/**
		 * 显示提示时的声音
		 */
		public var sound:String;
		/**
		 * 点击后自动隐藏
		 */
		public var hideAfterMouseDown:Boolean;
		/**
		 * 自动隐藏时长
		 */
		public var autoHideTime:Number=3;
		/**
		 * 声音播放时机，0是在角色出现时，1是在动画结束时，2是在字幕出现时
		 */
		public var soundPlayTime:int;
	}
}
