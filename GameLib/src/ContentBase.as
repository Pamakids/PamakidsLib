package
{
	import flash.display.Sprite;

	public class ContentBase extends Sprite implements IContent
	{
		private var _width:Number;
		private var _height:Number;

		public function ContentBase()
		{
		}

		/**
		 * 释放内容
		 */
		public function dispose():void
		{

		}

		public function get events():Array
		{
			return null;
		}

		public function initialize(width:Number, height:Number):void
		{
			this.width=width;
			this.height=height;
		}

		override public function set width(value:Number):void
		{
			_width=value;
		}

		override public function get width():Number
		{
			return _width;
		}

		override public function get height():Number
		{
			return _height;
		}

		override public function set height(value:Number):void
		{
			this.height=value;
		}

	}
}
