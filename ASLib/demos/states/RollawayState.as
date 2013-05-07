package states
{
	import com.greensock.TweenLite;
	import com.pamakids.components.controls.Image;
	import com.pamakids.components.controls.Rollaway;
	import com.pamakids.components.controls.RollawayGroup;
	import com.pamakids.events.RollawayEvent;
	import com.pamakids.layouts.TileLayout;
	
	import flash.events.Event;

	public class RollawayState extends State
	{


		private var RW:Rollaway
		private var RG:RollawayGroup
		
		override public function enter():void
		{
			var i:int, l:int
			var img:Image
			
			l = 8
			RG = new RollawayGroup((this.group.stage.stageWidth - 148)/2, this.group.stage.stageWidth)
				
			// A
			//RW=new Rollaway()
			while(i < l)
			{
				RW = RG.createRollaway()
				this.group.addChild(RW)
	
				//RW.layout=new TileLayout(2, 5, 5)
				img=new Image(0, 0)
				RW.y = 200
				img.source='assets/default/0' + (++i) + '.png';
				RW.addChild(img)
				
				RW.addEventListener(RollawayEvent.ROLL_RELEASE, onRollRelease)
			}

		}


		override public function exit():void
		{
			var RW:Rollaway
			var l:int = RG.list.length
			while(--l>-1)
			{
				RW =  RG.list[l]
				RW.removeEventListener(RollawayEvent.ROLL_RELEASE, onRollRelease)
				this.group.removeChild(RW)
			}
			
			RG = null
		}
		
		private function onChange(e:Event):void
		{
			TweenLite.killTweensOf(RW)

		}
		
		private function onRollRelease(e:RollawayEvent):void
		{
			trace(e.offset)
			/*var target:Rollaway = e.target as Rollaway
			if(e.offset != 0)
			{
				TweenLite.to(target, 1, {x:e.offset * 3 + target.goalX})
				
			}*/
		}
	}
}
