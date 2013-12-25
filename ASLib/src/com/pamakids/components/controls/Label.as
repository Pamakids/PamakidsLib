package com.pamakids.components.controls
{
	import com.pamakids.components.base.UIComponent;

	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	[Event(name="resize", type="com.pamakids.events.ResizeEvent")]

	/**
	 * 文本
	 */
	public class Label extends UIComponent
	{
		protected var textField:TextField;

		public function Label(text:String='', width:Number=0, height:Number=0)
		{
			this.text=text;
			super(width, height);
			if (!width && !height)
				forceAutoFill=true;
			cacheAsBitmap=Style.cacheAsBitmap;
			if (Style.embedFonts && !Style.fontLoaded)
			{
				Style.addFontCallback(function():void
				{
					textField.text=text;
				});
			}
		}

		public function getTextField():TextField
		{
			return textField;
		}

		public function get embedFonts():Boolean
		{
			return _embedFont ? _embedFont : Style.embedFonts;
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
				addChild(createTextField());
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
			return _fontFamily ? _fontFamily : Style.fontName;
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
			if (textField && (width > textField.width || autoCenter))
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
			return _text ? _text : textField.text;
		}

		public function set text(value:String):void
		{
			if (textField && textField.text == value)
				return;
			if (value == _text)
				return;
			_text=value;
			if (textField && value != null)
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
			if (type == TextFieldType.INPUT)
				return;
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
				addChild(createTextField());
				if (type != TextFieldType.INPUT)
					adjust();
				else if (width && height)
					centerDisplayObject(textField);
				else if (!width)
					width=textField.width;
				else
					height=textField.height;
			}
		}

		private var _embedFont:Boolean;
		public var selectable:Boolean;
		public var type:String=TextFieldType.DYNAMIC;

		public var multiline:Boolean;

		protected function createTextField():TextField
		{
			var tf:TextFormat=new TextFormat();
			tf.size=fontSize;
			tf.color=color;
			tf.font=fontFamily;
			tf.align=algin;
			textField=new TextField();
			textField.autoSize=TextFieldAutoSize.LEFT;
			if (!forceAutoFill && type != TextFieldType.INPUT)
				textField.wordWrap=true;
			textField.multiline=multiline;
			textField.type=type;
			textField.embedFonts=embedFonts;
			textField.selectable=selectable;
			textField.defaultTextFormat=tf;
			if (text)
				textField.text=text;
			var th:Number=textField.height;
			if (width)
			{
				if (type == TextFieldType.INPUT)
				{
					textField.autoSize=TextFieldAutoSize.NONE;
					textField.height=th;
				}
				textField.width=width;
			}
			else if (type == TextFieldType.INPUT)
			{
				var tw:Number=textField.width;
				textField.autoSize=TextFieldAutoSize.NONE;
				textField.height=th;
				textField.width=tw;
				setSize(tw, th);
			}
			return textField;
		}
	}
}
