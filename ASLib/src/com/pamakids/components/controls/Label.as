package com.pamakids.components.controls
{
	import com.pamakids.components.base.UIComponent;

	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	[Event(name="resize", type="com.pamakids.events.ResizeEvent")]
	public class Label extends UIComponent
	{
		protected var textField:TextField;

		public function Label(text:String='', width:Number=0, height:Number=0)
		{
			this.text=text;
			super(width, height);
			if (!width && !height)
				forceAutoFill=true;
		}

		public function get embedFonts():Boolean
		{
			return _embedFont;
		}

		public function set embedFonts(value:Boolean):void
		{
			_embedFont=value;
			if (textField)
				textField.embedFonts=value;
		}

		override public function set width(value:Number):void
		{
			super.width=value;
			if (value)
			{
				autoFill=false;
				forceAutoFill=false;
				if (textField)
				{
					textField.wordWrap=true;
					textField.width=value;
				}
			}
			else
			{
				forceAutoFill=true;
				if (textField)
					textField.wordWrap=false;
			}
		}

		private var _maxWidth:Number;
		private var _text:String;
		private var _fontSize:uint=12;
		private var _color:uint;
		private var _fontFamily:String;
		private var _algin:String;

		public function get maxWidth():Number
		{
			return _maxWidth;
		}

		public function set maxWidth(value:Number):void
		{
			if (_maxWidth && _maxWidth != value)
			{
				_maxWidth=value;
				forceAutoFill=true;
				if (textField)
					removeChild(textField);
				createTextField();
				updateFormat();
			}
			_maxWidth=value;
			measure();
		}

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

		override protected function resize():void
		{
			super.resize();
			adjust();
		}

		private function adjust():void
		{
			if (textField && width > textField.width)
				centerDisplayObject(textField);
		}

		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			if (value == _color)
				return;
			_color=value;
			updateFormat();
		}

		public function get fontSize():uint
		{
			return _fontSize;
		}

		public function set fontSize(value:uint):void
		{
			if (value == _fontSize)
				return;
			_fontSize=value;
			updateFormat();
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			if (value == _text)
				return;
			_text=value;
			if (textField)
			{
				textField.text=value;
				updateFormat();
			}
		}

		protected function measure():void
		{
			if (maxWidth && textField && width)
			{
				if (width > maxWidth)
				{
					width=maxWidth;
					textField.width=maxWidth;
					forceAutoFill=false;
				}
			}
		}

		override public function setSize(width:Number, height:Number):void
		{
			super.setSize(width, height);
			measure();
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
			if (!maxWidth || maxWidth > textField.width)
				forceAutoFill=true;
			autoSetSize(textField);
		}

		override protected function autoSetSize(child:DisplayObject):void
		{
			if (autoFill || forceAutoFill)
			{
				if (child == textField)
					setSize(textField.width, textField.height);
				else
					setSize(child.width > width ? child.width : width, child.height > height ? child.height : height);
			}
			else if (child == textField)
			{
				if (!height)
					height=textField.height;
				centerDisplayObject(textField);
			}
		}

		override protected function init():void
		{
			if (!textField)
			{
				createTextField();
				adjust();
			}
		}

		private var _embedFont:Boolean;

		protected function createTextField():void
		{
			var tf:TextFormat=new TextFormat();
			tf.size=fontSize;
			tf.color=color;
			tf.font=fontFamily;
			tf.align=algin;
			textField=new TextField();
			textField.autoSize=TextFieldAutoSize.LEFT;
			if (!forceAutoFill)
				textField.wordWrap=true;
			textField.embedFonts=embedFonts;
			textField.selectable=false;
			textField.defaultTextFormat=tf;
			if (width)
				textField.width=width;
			textField.text=text;
			addChild(textField);
		}
	}
}
