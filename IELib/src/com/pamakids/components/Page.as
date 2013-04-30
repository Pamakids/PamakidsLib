package com.pamakids.components
{
	import com.pamakids.components.controls.Image;

	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Page extends Image
	{
		public static const LEFT:uint=0;
		public static const RIGHT:uint=1;
		public static const PAGE_OPEN:String="pageOpen";
		public static const PAGE_OPENCOMPLETE:String="pageOpenComplete";
		public static const PAGE_CLOSE:String="pageClose";
		public static const PAGE_CLOSECOMPLETE:String="pageCloseComplete";

		public var lock:Boolean=false;
		public var side:uint=0;
		public var hard:Boolean;
		private var containerMC:Sprite;
		private var pageGraMC:Sprite;
		private var tempPageAreaMC:Shape;
		private var vectorX:int=1;
		private var pageMaskMC:Sprite;
		private var pageMaskGra:Shape;
		private var shadowMC:Shape;
		private var shadowMaskMC:Shape;
		private var mouseAreaMC:Sprite;
		private var baseMouseY:Number;

		public function Page(width:Number, height:Number)
		{
			super(width, height);
			containerMC=new Sprite();
			containerMC.y=height;
			addChild(containerMC);
			pageGraMC=new Sprite();
			pageGraMC.y=-height;
			containerMC.addChild(pageGraMC);
			tempPageSet();
			maskSet();
			mouseAreaSet();
			shadowSet();
		}

		private function tempPageSet():void
		{
			tempPageAreaMC=new Shape();
			tempPageAreaMC.graphics.beginFill(0xFFFFFF);
			tempPageAreaMC.graphics.lineStyle(1, 0xCCCCCC);
			tempPageAreaMC.graphics.drawRect(0, 0, vectorX * width, height);
			pageGraMC.addChildAt(tempPageAreaMC, 0);
		}

		private function maskSet():void
		{
			pageMaskMC=new Sprite();
			pageMaskMC.y=height;
			addChild(pageMaskMC);
			pageMaskGra=new Shape();
			pageMaskMC.addChild(pageMaskGra);

			pageMaskGra.graphics.beginFill(0xAAAAFF);
			pageMaskGra.graphics.drawRect(0, -height * 2, vectorX * height * 2, height * 3);
			containerMC.mask=pageMaskMC;
		}

		public var pageRightFlag:Boolean=true;
		private var state:String;
		private var movePerMax:int;
		private var autoFlipTimer:Timer;

		private function shadowSet():void
		{
			shadowMC=new Shape();
			shadowMC.y=height;
			if (pageRightFlag)
				shadowMC.graphics.beginGradientFill("linear", [0x000000, 0x000000], [0, 0.8], [0, 100]);
			else
				shadowMC.graphics.beginGradientFill("linear", [0x000000, 0x000000], [0.8, 0], [150, 255]);
			shadowMC.graphics.drawRect(0, -height * 2, vectorX * -100, height * 3);
			addChild(shadowMC);

			shadowMaskMC=new Shape();
			shadowMaskMC.graphics.beginFill(0x00CCCC);
			shadowMaskMC.graphics.drawRect(-width, 0, width * 2, height);
			addChild(shadowMaskMC);
			shadowMC.mask=shadowMaskMC;
			shadowMC.visible=false;
		}

		private function mouseAreaSet():void
		{
			mouseAreaMC=new Sprite();
			mouseAreaMC.graphics.beginFill(0xAAAAFF, 0);

			var mouseAreaPosiX:int=width - mouseAreaMC.width;
			var mouseAreaWidth:uint=width * 0.2;
			mouseAreaMC.graphics.drawRect(0, 0, vectorX * (-mouseAreaWidth), height);
			mouseAreaMC.x=vectorX * mouseAreaPosiX;
			addChild(mouseAreaMC);
			mouseAreaMC.addEventListener(MouseEvent.MOUSE_DOWN, nextPageHandler);

		}

		protected function nextPageHandler(event:MouseEvent):void
		{
			pageFlip();
		}

		public function pageFlip():void
		{
			if (lock)
				return;

			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
//			pageCurl('auto');
//			pageOpen();

			pageAutoOpen();
//			autoFlipTimer=new Timer(150);
//			autoFlipTimer.addEventListener(TimerEvent.TIMER, onAutoFlipTimer);
//			autoFlipTimer.start();

//			pageEnterStart();
		}

		private function onAutoFlipTimer(event:TimerEvent):void
		{
			pageAutoOpen();
		}

		private function pageAutoStop():void
		{
			if (autoFlipTimer)
			{
				autoFlipTimer.reset();
				autoFlipTimer.removeEventListener(TimerEvent.TIMER, onAutoFlipTimer);
				autoFlipTimer=null;
			}
		}

		private function pageAutoOpen():void
		{
			pageCurl('auto');
			pageOpen();
//			var targetNo:uint;
//			if (selectedOpenPageNo == (Math.floor(autoTargetPageNo / 2) + 0.5) * 2)
//			{
//				pageAutoStop();
//			}
//			else
//			{
//				if (autoTargetPageNo > selectedOpenPageNo)
//				{
//					targetNo=selectedOpenPageNo + 1;
//				}
//				else if (autoTargetPageNo < selectedOpenPageNo - 1)
//				{
//					targetNo=selectedOpenPageNo - 2;
//				}
//				if (pageArray[targetNo - 1])
//				{
//					pageArray[targetNo - 1].pageCurl("auto");
//					pageArray[targetNo - 1].pageOpen();
//				}
//				else
//				{
//					pageAutoStop();
//				}
//			}
		}

		public function pageOpen():void
		{
//			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
//			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			state="open";
			movePerMax=1;
//			digitalbookMC.selectedOpenPageNo=(Math.floor(ID / 2) + 0.5) * 2;
//			if (digitalbookMC.bookState != "autoOpen")
//			{
//				dispatchOpenEvent();
//				if (sidePageMC)
//				{
//					sidePageMC.dispatchOpenEvent();
//					sidePageMC.mouseSet(true);
//				}
//			}
//			maskedPageMC.dispatchCloseEvent();
//			if (backPageMC)
//			{
//				backPageMC.dispatchCloseEvent();
//				backPageMC.mouseSet(false);
//			}
//			mouseSet(false);
		}

		private function pageEnterStart():void
		{
			addEventListener(Event.ENTER_FRAME, onPageEnter);
		}

		private function setAutoFlipData():void
		{
			state='open';
			baseMouseY=mouseY;
//			baseMouseY=height / 2 + 40 - Math.floor(80 * Math.random());
		}

		public function pageCurl(str:String="manual"):void
		{
			state="curl";
			movePerMax=0;
			movePerMax=0.1;
			baseMouseY=height / 2;
			x=vectorX * (-width);
//			maskedPageMC.pageMaskGra.x=vectorX * maskedPageMC.pageMaskGra.width;

			pageMaskGra.x=0;
			pageGraMC.x=x
			shadowMaskMC.x=-x;

			parent.setChildIndex(this, parent.numChildren - 1);

			var defaultRotation:Number=0;
			var defaultY:Number=height;

			if (str == "auto")
			{
				defaultRotation=30 - Math.floor(60 * Math.random());
				baseMouseY=height / 2 + 40 - Math.floor(80 * Math.random());
			}
			else
			{
				if (mouseY < height * 0.2)
				{
					baseMouseY=0;
					defaultRotation=vectorX * 45;
					defaultY=0;
				}
				else if (mouseY > height * 0.8)
				{
					defaultRotation=vectorX * -45;
					baseMouseY=height;
				}
				else
				{
					state="wait";
				}
			}

			containerMC.y=defaultY;
			containerMC.rotation=defaultRotation * 2;
			pageGraMC.y=-containerMC.y;
			pageMaskMC.y=containerMC.y;
			pageMaskMC.rotation=defaultRotation;

			shadowMC.y=containerMC.y;
			shadowMC.rotation=defaultRotation;

//			maskedPageMC.pageMaskMC.y=containerMC.y;
//			maskedPageMC.pageMaskMC.rotation=pageMaskMC.rotation;

			if (state == "curl")
			{
				addEventListener(Event.ENTER_FRAME, onPageEnter);
			}
			pageEnterStart();
//			if (state == "autoOpen")
//			{
//				pageEnterStart();
//			}
//			else
//			{
//				addEventListener(Event.ENTER_FRAME, onMouseCheckEnter);
//			}
//			stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);

//			mouseSet(false);
//			maskedPageMC.mouseSet(false);
//			if (backPageMC)
//			{
//				backPageMC.mouseSet(false);
//			}
//			if (sidePageMC)
//			{
//				sidePageMC.mouseSet(false);
//			}
			shadowMC.visible=true;
//			visibleSet(true);
		}

		protected function onPageEnter(event:Event):void
		{
			setAutoFlipData();
			var accelNum:Number=0.15;
			var targetX:int;
			var targetY:Number=height;
			var targetBaseX:int;
			var adjustX:Number=0;
			var r:Number=0;
			var targetRotation:Number=0;
			var rotationLimit:Number=0;
			var mouseDistanceX:Number=width + (vectorX * parent.mouseX);
			var mouseDistanceY:int=baseMouseY - parent.mouseY;

			//移動の計算
			if (state == "open")
			{
				mouseDistanceX=width * 2;
				mouseDistanceY=baseMouseY;
			}
			else if (state == "flat" || state == "wait")
			{
				mouseDistanceX=0;
				mouseDistanceY=baseMouseY;
				if (baseMouseY == 0)
				{
					targetY=0;
				}
			}
			else
			{
				if (mouseDistanceX < 10)
				{
					mouseDistanceX=10;
				}
				targetRotation=-vectorX * Math.atan(mouseDistanceY / mouseDistanceX) * 180 / Math.PI;
			}

			var centerX:Number=mouseDistanceX / 2;
			var centerY:Number=(baseMouseY + parent.mouseY) / 2;
			r=(90 - targetRotation) * Math.PI / 180;
			adjustX=(height - centerY) / Math.tan(r);
			targetBaseX=-vectorX * (width - centerX);
			targetX=targetBaseX - adjustX;

			//移動制限
			r=(vectorX * -targetRotation) * Math.PI / 180;
			if (vectorX * targetX > 0)
			{
				targetX=0;
			}
			else if (vectorX * targetX < -width)
			{
				targetY=height - (width + vectorX * targetX) / Math.tan(r);
				if (targetY < 0)
				{
					targetY=0;
				}
				else if (targetY > height)
				{
					targetY=height;
				}
				targetX=vectorX * -width;
			}

			//回転制限
			rotationLimit=(Math.atan(-targetX / targetY) * 180 / Math.PI);

			if (vectorX * targetRotation > vectorX * rotationLimit)
			{
				targetRotation=rotationLimit;
			}
			else if (vectorX * targetRotation > 90)
			{
				targetRotation=vectorX * 90;
			}

			//動作
			var moveDistance:Number=targetX - x;
			x+=moveDistance * accelNum;
			containerMC.y+=(targetY - containerMC.y) * accelNum;
			pageGraMC.x=x;
			pageGraMC.y=-containerMC.y;
			pageMaskMC.y=containerMC.y;
			//最終角度
			var resultRotation:Number=pageMaskMC.rotation + (targetRotation - pageMaskMC.rotation) * accelNum;
			rotationLimit=(Math.atan(-x / containerMC.y) * 180 / Math.PI);
			if (vectorX * resultRotation > vectorX * rotationLimit)
			{
				resultRotation=rotationLimit;
			}
			pageMaskMC.rotation=resultRotation;
			containerMC.rotation=resultRotation * 2;

			shadowMC.rotation=pageMaskMC.rotation;
			shadowMC.alpha=-vectorX * (targetBaseX / width);
			shadowMC.scaleX=(vectorX * targetBaseX / width) + 1.05;
			shadowMC.y=containerMC.y;
			shadowMaskMC.x=-x;

//			maskedPageMC.pageMaskMC.x=x;
//			maskedPageMC.pageMaskMC.y=containerMC.y;
//			maskedPageMC.pageMaskMC.rotation=pageMaskMC.rotation;
			if (state == 'open')
				trace('onPageEnter:', state, moveDistance, containerMC.rotation);
			//動作完了
			if (Math.abs(moveDistance) < 0.5 && Math.abs(containerMC.rotation) < 0.5)
			{
//				if (state == "open")
//				{
//					pageOpenComplete();
//				}
//				else if (state == "flat")
//				{
//					pageFlatComplete();
//				}
				pageAutoStop();
				removeEventListener(Event.ENTER_FRAME, onPageEnter);
			}
		}

		protected function mouseUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		override protected function addContent(content:Bitmap):void
		{
			pageGraMC.addChild(content);
			addListeners();
		}

		private function addListeners():void
		{

		}

		private function removeListeners():void
		{

		}

		override protected function dispose():void
		{
			super.dispose();
			removeListeners();
			while (numChildren)
			{
				removeChildAt(0);
			}
		}

	}
}
