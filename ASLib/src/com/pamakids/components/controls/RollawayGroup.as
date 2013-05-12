package com.pamakids.components.controls
{
	import com.greensock.TweenLite;

	public class RollawayGroup
	{
		public function RollawayGroup(startX:Number, gap:Number, offsetForChange:Number=150, speedForChange:Number=5)
		{
			mStartX=startX
			mGap=gap
			mOffsetForChange=offsetForChange
			mSpeedForChange=speedForChange
		}



		public function get pressedIndex():int
		{
			return mPressedIndex
		}


		public function get list():Array
		{
			return mRollawayList
		}


		public function createRollaway():Rollaway
		{
			var RW:Rollaway=new Rollaway()
			var l:int=mRollawayList.push(RW)
			RW.x=(l - 1) * mGap + mStartX
			RW.mGroup=this
			return RW
		}


		internal function calculateCoordinates(speed:int):void
		{
			var RW:Rollaway=mRollawayList[mPressedIndex]
			var index:int
			var l:int=mRollawayList.length

			if (RW.x > mStartX + mOffsetForChange || speed > mSpeedForChange)
			{
				index=mPressedIndex - 1
				toPage(index=index < 0 ? 0 : index)
				trace('prev')
			}

			else if (RW.x < mStartX - mOffsetForChange || speed < -mSpeedForChange)
			{
				index=mPressedIndex + 1
				trace('next')
				toPage(index >= l ? l - 1 : index)
			}

			else
			{
				toPage(mPressedIndex)
			}
		}

		internal function toPage(index:int):void
		{
			var item:Rollaway
			var l:int=mRollawayList.length

			trace('[index] - ' + index)
			while (--l > -1)
			{
				item=mRollawayList[l]
				TweenLite.to(item, 1, {x: (l - index) * mGap + mStartX, overwrite: 1})
			}
		}

		internal function clearAllTweens():void
		{
			var item:Rollaway
			var l:int
			var list:Array

			list=mRollawayList
			l=list.length
			while (--l > -1)
			{
				TweenLite.killTweensOf(list[l])
			}
		}

		internal var mRollawayList:Array=[]

		internal var mPressedIndex:int

		internal var mStartX:Number

		internal var mGap:Number

		internal var mSpeedForChange:Number

		internal var mOffsetForChange:Number


	}
}
