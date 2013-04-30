package model.content
{
	import model.consts.ShowPosition;

	[Bindable]
	public class SubtitleVO
	{
		public function SubtitleVO()
		{
			showPosition=ShowPosition.BOTTOM;
		}
		public var startTime:Number=0;
		public var endTime:Number=0;
		public var text:String;
		public var color:uint;
		public var fontSize:uint;
		/**
		 * 字幕出现的方向
		 */
		public var showPosition:String;
		/**
		 * 字幕出现的效果
		 */
		public var showEffect:String;
		/**
		 * 效果时间
		 */
		public var effectDuration:Number=0.8;

		/**
		 * 字幕相对背景位置
		 */
		public var paddingLeft:Number=0;
		public var paddingRight:Number=0;
		public var paddingTop:Number=0;
		public var paddingBottom:Number=0;
		/**
		 * 九宫格信息
		 */
		public var backgroundScaleGrid:Array;

		/**
		 * 字幕背景
		 */
		public var background:String;

		/**
		 * 文字遮罩相对位置
		 */
		public var frontLeft:Number=0;
		public var frontRight:Number=0;
		public var frontTop:Number=0;
		/**
		 * 前景遮罩
		 */
		public var frontMask:String;
		public var frontMaskScalGrid:Array;
		/**
		 * 字幕最大宽度
		 */
		public var maxWidth:Number=0;

	}
}
