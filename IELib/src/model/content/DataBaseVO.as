package model.content
{

	public class DataBaseVO
	{
		public function DataBaseVO()
		{
		}

		/**
		 * 事件执行时间间隔
		 */
		public var eventInterval:Number=0;
		/**
		 * 交互提示间隔时间
		 */
		public var promptInterval:Number=0;
		/**
		 * 闪烁提示持续时间
		 */
		public var promptDuration:Number=3;

		/**
		 * 字幕距离底部像素
		 */
		public var subtitleGap:Number=30;
		public var subtitleFontSize:Number=16;
		public var subtitleFontColor:uint=0xffffff;
	}
}
