package com.pamakids.vo
{
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Strong;

	import flash.utils.ByteArray;



	public class BezierVo
	{


		public var startX:Number

		public var startY:Number


		public var alphaMin:Number

		public var alphaMax:Number


		public var scaleMin:Number

		public var scaleMax:Number


		public var delayMin:Number

		public var delayMax:Number


		public var durationMin:Number

		public var durationMax:Number


		public var roundMin:Number

		public var roundMax:Number


		public var nextRoundMin:Number

		public var nextRoundMax:Number


		public var maxPerFrame:int

		public var probability:Number

		public var maxMotions:int


		public var ease:String;

		public var frameRate:Number;

		public var bezierPoints:Array




		public function get easeFunction():Function
		{
			var easeFuction:Function

			switch (ease)
			{
				case "Cubic.easeOut":
					easeFuction=Cubic.easeOut
					break;

				case "Cubic.easeIn":
					easeFuction=Cubic.easeIn
					break

				case "Linear.easeNone":
					easeFuction=Linear.easeNone
					break;

				case "Linear.easeOut":
					easeFuction=Linear.easeOut
					break;

				case "Linear.easeIn":
					easeFuction=Linear.easeIn

				case "Strong.easeOut":
					easeFuction=Strong.easeOut
					break

				case "Strong.easeIn":
					easeFuction=Strong.easeIn
					break
			}

			return easeFuction
		}


		public function fromByteArray(ba:ByteArray):void
		{
			if (!ba || !ba.length)
				return;
			ba.position=0;
			var o:Object=ba.readObject() as Object

			startX=o.startX
			startY=o.startY

			alphaMin=o.alphaMin
			alphaMax=o.alphaMax

			delayMin=o.delayMin
			delayMax=o.delayMax

			durationMin=o.durationMin
			durationMax=o.durationMax

			scaleMin=o.scaleMin
			scaleMax=o.scaleMax

			nextRoundMin=o.nextRoundMin
			nextRoundMax=o.nextRoundMax

			roundMin=o.roundMin
			roundMax=o.roundMax

			probability=o.probability
			maxMotions=o.maxMotions
			maxPerFrame=o.maxPerFrame
			frameRate=o.frameRate
			ease=o.ease

			var l:int=ba.readShort()
			bezierPoints=[]
			while (--l > -1)
			{
				bezierPoints.push(ba.readDouble())
			}

			//trace(bezierPoints)
		}


		public function toByteArray():ByteArray
		{
			var ba:ByteArray=new ByteArray()
			ba.writeObject(this)

			var i:int, l:int=bezierPoints.length
			ba.writeShort(l)
			while (i < l)
			{
				ba.writeDouble(bezierPoints[i++])
			}
			return ba
		}

	}
}
