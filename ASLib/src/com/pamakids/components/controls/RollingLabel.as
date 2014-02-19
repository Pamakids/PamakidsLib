package com.pamakids.components.controls
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * 滚动文本
	 * @author mani
	 */
	public class RollingLabel extends Label
	{
		public function RollingLabel(text:String='', width:Number=0, height:Number=0)
		{
			super(text, width, height);
		}

		private const MAX_ROLL_NUM:int=20;

		private var _enableRoll:Boolean;

		private var acceleration:Number=1;
		private var maskSprite:Sprite;
		private var rollNumbers:Vector.<Number>;

		private var tf1:TextField;
		private var tf2:TextField;

		override protected function init():void
		{
			initRollNumbers();
			tf1=createTextField();
			tf1.text=prefix + rollNumbers[0].toString();
			addChild(tf1);
			tf2=createTextField();
			addChild(tf2);
			tf2.y=height;
			moveTextFields();
		}

		public var prefix:String="";

		override protected function dispose():void
		{
			TweenMax.killChildTweensOf(this);
		}

		override protected function resize():void
		{
			super.resize();
			updateMask();
		}

		override protected function autoSetSize(child:DisplayObject):void
		{
			var changed:Boolean=child.width > width || child.height > height;
			if (changed)
				setSize(child.width > width ? child.width : width, child.height > height ? child.height : height);
		}

		protected function resizeHandler(event:Event):void
		{
			setSize(event.currentTarget.width, event.currentTarget.height);
		}

		private var hasAddedValue:Boolean;

		public function add(value:int):void
		{
			var textValue:int=rollNumbers.length ? rollNumbers[rollNumbers.length - 1] : parseInt(text);
			for (var i:int=1; i <= value; i++)
			{
				rollNumbers.push(textValue + i);
			}
			if (!isMoving)
			{
				hasAddedValue=true;
				moveTextFields();
			}
			text=(textValue + value).toString();
		}

		private function initRollNumbers():void
		{
			rollNumbers=new Vector.<Number>();
			var number:int=parseInt(text);
			var allNumbers:Vector.<Number>=new Vector.<Number>();
			for (var i:int; i <= number; i++)
			{
				allNumbers.push(i);
			}
			if (number < MAX_ROLL_NUM)
			{
				rollNumbers=allNumbers;
			}
			else
			{
				i=0;
				allNumbers.splice(allNumbers.length - 1, 1);
				for (i; i < MAX_ROLL_NUM; i++)
				{
					var index:int=Math.ceil(Math.random() * allNumbers.length - 1);
					var value:int=allNumbers[index];
					allNumbers.splice(index, 1);
					rollNumbers.push(value);
				}
				rollNumbers.push(number);
				rollNumbers.sort(sortEsc);
			}
		}

		public var endFunction:Function;
		private var isMoving:Boolean;

		private function moveTextFields():void
		{
			if (!rollNumbers.length)
			{
				acceleration=1;
				isMoving=false;
				if (endFunction != null && hasAddedValue)
					endFunction();
				return;
			}
			isMoving=true;
			if (tf1.y < 0)
				tf1.y=height;
			if (tf2.y < 0)
				tf2.y=height;
			if (rollNumbers.length == 1)
			{
				var num:String=prefix + rollNumbers.shift().toString();
				tf1.y == height ? tf1.text=num : tf2.text=num;
			}
			else if (rollNumbers.length == 2)
			{
				var num1:String=prefix + rollNumbers.shift().toString();
				var num2:String=prefix + rollNumbers.shift().toString();
				tf1.text=tf1.y == height ? num2 : num1;
				tf2.text=tf2.y == height ? num2 : num1;
			}
			else
			{
				tf1.text=prefix + rollNumbers.shift().toString();
				tf2.text=prefix + rollNumbers.shift().toString();
			}
			autoSetSize(tf1);
			autoSetSize(tf2);
			var duration:Number=!rollNumbers.length ? 1 : 0.55 - 0.5 * acceleration;
			var ease:Function=!rollNumbers.length ? Elastic.easeOut : Cubic.easeOut;
			TweenMax.allTo([tf1, tf2], duration, {y: "-" + height, ease: ease}, 0, moveTextFields);
			acceleration-=acceleration / MAX_ROLL_NUM;
		}

		private function sortEsc(a:int, b:int):int
		{
			var result:int;
			if (a > b)
				result=1;
			else if (a < b)
				result=-1;
			return result;
		}

		private function updateMask():void
		{
			if (!maskSprite)
			{
				maskSprite=new Sprite();
				addChild(maskSprite);
				mask=maskSprite;
			}
			maskSprite.graphics.beginFill(0);
			maskSprite.graphics.drawRect(0, 0, width, height);
			maskSprite.graphics.endFill();
		}
	}
}
