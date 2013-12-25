package com.pamakids.components.controls
{
	import com.pamakids.components.base.UIComponent;

	/**
	 * 线
	 * @author mani
	 */
	public class Line extends UIComponent
	{
		private var _length:Number;
		private var _color:uint;
		private var _horizontal:Boolean;
		private var _weight:Number;

		public function Line(length:Number, color:uint, horizontal:Boolean=true, weight:Number=1)
		{
			this.length=length;
			this.color=color;
			this.horizontal=horizontal;
			this.weight=weight;
			super(horizontal ? length : weight, horizontal ? weight : length);
			drawLine();
		}

		public function get weight():Number
		{
			return _weight;
		}

		public function set weight(value:Number):void
		{
			_weight=value;
			drawLine();
		}

		public function get horizontal():Boolean
		{
			return _horizontal;
		}

		public function set horizontal(value:Boolean):void
		{
			_horizontal=value;
			drawLine();
		}

		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			_color=value;
			drawLine();
		}

		public function get length():Number
		{
			return _length;
		}

		public function set length(value:Number):void
		{
			_length=value;
			drawLine();
		}

		private function drawLine():void
		{
			graphics.clear();
			graphics.lineStyle(weight, color);
			graphics.moveTo(0, 0);
			graphics.lineTo(horizontal ? length : 0, horizontal ? 0 : length);
		}
	}
}
