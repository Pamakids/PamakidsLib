package com.pamakids.components.controls
{
	import com.pamakids.components.base.Container;

	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	[Event(name="resize", type="com.pamakids.events.ResizeEvent")]
	public class Label extends Container
	{
		protected var textField:TextField;

		public function Label(text:String='', width:Number=0, height:Number=0)
		{
			this.text=text;
			super(width, height);
			if (!width || !height)
				forceAutoFill=true;
		}

		private var _text:String;
		private var _fontSize:uint=12;
		private var _color:uint;
		private var _background:ScaleBitmap;
		private var _fontFamily:String;
		private var _algin:String;

		public function get algin():String
		{
			if (!_algin)
				_algin=TextFormatAlign.CENTER;
			return _algin;
		}

		public function set algin(value:String):void
		{
			_algin=value;
			updateFormat();
		}

		public function get fontFamily():String
		{
			return _fontFamily;
		}

		public function set fontFamily(value:String):void
		{
			_fontFamily=value;
			updateFormat();
		}

		public function get background():ScaleBitmap
		{
			return _background;
		}

		public function set background(value:ScaleBitmap):void
		{
			if (_background)
			{
				_background.bitmapData.dispose();
				removeChild(_background);
			}
			else
			{
				autoSetSize(_background);
				addChildAt(_background, 0);
			}
			_background=value;
		}

		override protected function resize():void
		{
			super.resize();
			adjust();
		}

		private function adjust():void
		{
			if (_background && width > _background.width)
				_background.setSize(width, height);
			if (!forceAutoFill && textField && width > textField.width)
				centerDisplayObject(textField);
		}

		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			_color=value;
			updateFormat();
		}

		public function get fontSize():uint
		{
			return _fontSize;
		}

		public function set fontSize(value:uint):void
		{
			_fontSize=value;
			updateFormat();
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text=value;
			if (textField)
			{
				textField.text=value;
				autoSetSize(textField);
			}
		}

		protected function updateFormat():void
		{
			if (!textField)
				return;
			var tf:TextFormat=new TextFormat();
			tf.size=fontSize;
			tf.color=color;
			tf.font=fontFamily;
			tf.align=algin;
			textField.setTextFormat(tf);
			autoSetSize(textField);
		}

		override protected function autoSetSize(child:DisplayObject):void
		{
			if (autoFill || forceAutoFill)
			{
				textField.width=textField.textWidth;
				textField.height=textField.textHeight;
				if (child == textField)
					setSize(textField.width, textField.height);
				else
					setSize(child.width > width ? child.width : width, child.height > height ? child.height : height);
			}
		}

		override protected function init():void
		{
			var tf:TextFormat=new TextFormat();
			tf.size=fontSize;
			tf.color=color;
			tf.font=fontFamily;
			tf.align=algin;
			textField=new TextField();
			textField.multiline=true;
			textField.selectable=false;
			textField.defaultTextFormat=tf;
			textField.text=text;
			addChild(textField);
			adjust();
		}
	}
}
