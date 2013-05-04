package views.hotArea
{
	import com.greensock.TweenLite;
	import com.pamakids.components.base.Container;
	import com.pamakids.components.controls.SoundPlayer;
	import com.pamakids.manager.LoadManager;

	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import controller.PC;

	import model.content.HotAreaVO;

	[Event(name="clickHotArea", type="flash.events.Event")]
	public class HotAreaContainer extends Container
	{
		public function HotAreaContainer(width:Number=0, height:Number=0)
		{
			backgroudAlpha=0;
			voDic=new Dictionary();
			rectDic=new Dictionary();
			soundPlayer=new SoundPlayer();
			pc=PC.i;
			lm=LoadManager.instance;
			super(width, height, true, false);
		}

		private var hotAreas:Array;

		public function initHotAreas(hotAreas:Array):void
		{
			clear();
			this.hotAreas=hotAreas;
			if (this.hotAreas)
			{
				for each (var vo:HotAreaVO in hotAreas)
				{
					createHotArea(vo);
				}
			}
		}

		public function clear():void
		{
			while (numChildren)
				removeChildAt(0);
			hotAreas=[];
			clearDic(voDic);
			clearDic(rectDic);
		}

		private function clearDic(dic:Dictionary):void
		{
			for (var i:* in dic)
				delete dic[i];
		}

		private function createHotArea(vo:HotAreaVO):void
		{
			var u:Sprite=new Sprite();
			listenHotArea(u);
			voDic[u]=vo;
			if (vo.url)
			{
				var isSwf:Boolean=vo.url.indexOf('.swf') != -1;
				if (isSwf)
					lm.load(pc.getUrl(vo.url), loadedSwfHandler, null, [u, vo], null, false, LoadManager.SWF);
				else
					lm.load(pc.getUrl(vo.url), loadedImageHandler, null, [u, vo], null, false, LoadManager.BITMAP);
			}
			u.x=vo.x;
			u.y=vo.y;
			var g:Graphics=u.graphics;
			if (vo.commands)
			{
				g.lineStyle(1, 0, 0);
				g.beginFill(0, 0);
				var cmds:Vector.<int>=new Vector.<int>();
				var arr:Array=vo.commands.split(',');
				var s:String;
				for each (s in arr)
				{
					cmds.push(parseInt(s));
				}
				arr=vo.coords.split(',');
				var corrds:Vector.<Number>=new Vector.<Number>();
				for each (s in arr)
				{
					corrds.push(parseFloat(s));
				}
				g.drawPath(cmds, corrds);
				rectDic[u]=[cmds, corrds];
			}
			else
			{
				g.beginFill(0, 0);
				g.drawRect(0, 0, vo.width, vo.height);
				g.endFill();
				rectDic[u]=new Rectangle(vo.x, vo.y, vo.width, vo.height);
			}
			addChild(u);
		}

		private var downPoint:Point;
		private var voDic:Dictionary;
		private var rectDic:Dictionary;

		private function listenHotArea(u:Sprite):void
		{
			u.addEventListener(MouseEvent.MOUSE_DOWN, itemDownHandler);
		}

		private var clickedTarget:Sprite;

		public var clickedVO:HotAreaVO;
		private var soundPlayer:SoundPlayer;
		private var pc:PC;
		private var lm:LoadManager;

		protected function itemDownHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			clickedTarget=event.currentTarget as Sprite;
			downPoint=new Point(event.stageX, event.stageY);
			stage.addEventListener(MouseEvent.MOUSE_UP, itemMouseUpHandler);
		}

		protected function itemMouseUpHandler(event:MouseEvent):void
		{
			var xoffset:Number=event.stageX - downPoint.x;
			var yoffset:Number=event.stageY - downPoint.y;
			if (Math.abs(xoffset) < 20 || Math.abs(yoffset) < 20)
				clickedItem();
			stage.removeEventListener(MouseEvent.MOUSE_UP, itemMouseUpHandler);
		}

		private function clickedItem():void
		{
			clickedVO=voDic[clickedTarget];
			if (clickedVO.sound)
				soundPlayer.url=pc.getUrl(clickedVO.sound);
			if (clickedVO.showMethod && clickedTarget.numChildren)
				TweenLite.to(clickedTarget.getChildAt(0), 0.8, {alpha: 1});
			if (clickedVO.effect)
				pc.playHotArea(clickedVO, clickedTarget);
			dispatchEvent(new Event('clickHotArea'));
		}

		private function loadedSwfHandler(content:Sprite, target:Array):void
		{
			if ((target[1] as HotAreaVO).showMethod)
				content.alpha=0;
			(target[0] as Sprite).addChild(content);
		}

		private function loadedImageHandler(content:Bitmap, target:Array):void
		{
			if ((target[1] as HotAreaVO).showMethod)
				content.alpha=0;
			(target[0] as Sprite).addChild(content);
		}
	}
}
