package com.pamakids.components.controls
{
	import com.greensock.TweenLite;
	import com.pamakids.events;
	import com.pamakids.components.base.Container;
	import com.pamakids.events.RollawayEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	[Event(name="rollRelease", type="com.pamakids.events.RollawayEvent")]
	
	[Event(name="change", type="flash.events.Event")]

	public class Rollaway extends Container
	{
		public function Rollaway()
		{
			super(0,0,false,false)
			this.addEventListener(Event.ADDED_TO_STAGE, init)
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init)
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove)
			this.addEventListener(MouseEvent.MOUSE_DOWN, onPress)
		}

		
		
		public function get tweenTime():Number
		{
			return mTweenTime
		}
		
		public function set tweenTime(v:Number):void
		{
			mTweenTime = v
		}
		
		
		public function get goalX():Number
		{
			return mOffsetX + stage.mouseX
		}
		
		
		
		private function onRemove(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove)
			this.dispose()
		}



		override protected function dispose():void
		{
			var item:Rollaway
			var l:int
			var list:Array
			
			super.dispose()
			TweenLite.killTweensOf(this)
			
			if (mPressed)
			{
				//stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove)
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp)
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrame)
			}
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onPress)

			mGroup = null
		}


		private function onPress(e:MouseEvent):void
		{
			var item:Rollaway
			var l:int
			var list:Array
			
			mPressed=true
			mGroup.clearAllTweens()
			//stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove)
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp)
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame)
				
			mMouseX=stage.mouseX
			mOffsetX = this.x - e.stageX
			mOldX = stage.mouseX
				
			mGroup.mPressedIndex = mGroup.mRollawayList.indexOf(this)
		}

		private function onEnterFrame(e:Event):void
		{
			var tx:Number
			var item:Rollaway
			var l:int
			var list:Array
			
			if(mOldX != stage.mouseX)
			{
				tx = stage.mouseX - mOldX
				
				list = mGroup.mRollawayList
				l = list.length
				while(--l>-1)
				{
					item = list[l]
					item.x += tx
					//TweenLite.to(item,mTweenTime,{x:item.x + tx, overwrite:1})
				}
			}
			
			mOldX = stage.mouseX
			
			mMouseX=stage.mouseX
		}

		private function onMouseUp(e:MouseEvent):void
		{
			mPressed=false
			//stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove)
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp)
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame)

			mOffsetX = 0
			//this.dispatchEvent(new RollawayEvent(RollawayEvent.ROLL_RELEASE, stage.mouseX - mMouseX))
				
			mGroup.calculateCoordinates(stage.mouseX - mMouseX)
		}


		

		internal var mPadding:Number=0

		internal var mTweenTime:Number=0.2
			
		internal var mMouseX:Number

		internal var mPressed:Boolean
		
		internal var mGroup:RollawayGroup
		
		internal var mOffsetX:Number = 0
		internal var mOffsetY:Number
		
		internal var mOldX:Number
		internal var mOldY:Number
		
	}
}
