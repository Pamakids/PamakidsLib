package views
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.MotionBlurPlugin;
	import com.greensock.plugins.ShakeEffect;
	import com.greensock.plugins.TransformAroundCenterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.pamakids.components.base.Container;
	import com.pamakids.components.controls.Image;
	import com.pamakids.components.controls.ScaleBitmap;
	import com.pamakids.components.controls.SoundPlayer;
	import com.pamakids.content.ContentBase;
	import com.pamakids.events.ResizeEvent;
	import com.pamakids.manager.LoadManager;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	import controller.PC;

	import model.consts.Const;
	import model.content.BookVO;
	import model.content.ConversationVO;
	import model.content.EventsVO;
	import model.content.HotAreaVO;
	import model.content.HotPointVO;
	import model.content.SubtitleVO;

	import views.book.Avatar;
	import views.book.Subtitle;
	import views.hotArea.HotAreaContainer;

	public class BookPlayer extends Container
	{

		public function BookPlayer(width:Number, height:Number)
		{
			backgroudAlpha=1;
			backgroundColor=0x282828;
			TweenPlugin.activate([MotionBlurPlugin, TransformAroundCenterPlugin, ShakeEffect]);
			super(width, height, false, false);
			pc=PC.i;
			pc.width=width;
			pc.height=height;
			lm=LoadManager.instance;
		}

		public var settingStartPosition:Boolean=true;

		private var _vo:BookVO;

		private var centerImage:Image;
		private var conversationVO:ConversationVO;

		private var currentAvatar:Avatar;

		private var currentPageVO:HotPointVO;
		private var currentPageNum:int;
		private var currentPage:Sprite;

		private var eventsVO:EventsVO;
		private var otherImage:Image;
		private var pc:PC;

		private var positionTargets:Dictionary=new Dictionary();
		private var subtitle:Subtitle;
		private var _subtitleVO:SubtitleVO;

		public function get subtitleVO():SubtitleVO
		{
			return _subtitleVO ? _subtitleVO : conversationVO;
		}

		public function set subtitleVO(value:SubtitleVO):void
		{
			_subtitleVO=value;
		}

		private var playingPage:int;

		public function play(page:int=0):void
		{
			clearPostionContents();
			stopPreview();
			playingPage=page;
			show(page);
			if (currentPageVO.events)
			{
				eventsList=currentPageVO.events.concat();
				if (eventsList && eventsList.length)
				{
					eventsVO=eventsList.shift();
					playEvent();
				}
			}
			else
			{
				playEventComplete();
			}
		}

		private var playingAvatar:Avatar;
		private var intervalTimer:Timer;

		private function clearPreview():void
		{
			if (playingAvatar)
			{
				removeChild(playingAvatar);
				playingAvatar=null;
			}
			clearAvatars(avatarDic);
		}

		public function previewContent(vo:Object):void
		{
			subtitleVO=vo as SubtitleVO;
			conversationVO=vo as ConversationVO;
			stopPreview();
			if (conversationVO)
			{
				clearPostionContents();
				if (!playingAvatar)
				{
					playingAvatar=getAvatar(conversationVO);
				}
				else
				{
					playingAvatar.vo=conversationVO;
					pc.showVO(conversationVO, playingAvatar, avatarShown);
				}
			}
			else if (subtitleVO)
			{
				playSubtitle(true);
			}
			else
			{
				clearPostionContents();
				clearPreview();
				eventsVO=vo as EventsVO;
				if (eventsVO)
					playEvent(true);
			}
		}

		private function getAvatar(vo:ConversationVO):Avatar
		{
			var a:Avatar=new Avatar(vo);
			a.addEventListener(Event.COMPLETE, avatarCompleteHandler);
			addChild(a);
			return a;
		}

		protected function avatarCompleteHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, avatarCompleteHandler);
			pc.showVO(conversationVO, event.currentTarget as Avatar, avatarShown);
		}

		private function avatarShown():void
		{
			if (conversationVO.text)
			{
				subtitle.alpha=0;
				subtitle.useInPreview=true;
				subtitle.visible=true;
				if (subtitle.vo != conversationVO)
				{
					if (conversationVO.background)
						lm.load(pc.getUrl(conversationVO.background), backGroundLoadedHandler, null, null, null, false, LoadManager.BITMAP);
					if (conversationVO.frontMask)
						lm.load(pc.getUrl(conversationVO.frontMask), frontMaskLoadedHandler, null, null, null, false, LoadManager.BITMAP);
				}
				subtitle.vo=conversationVO;
				subtitle.x=playingAvatar.x + conversationVO.subtitleX;
				subtitle.y=playingAvatar.y + conversationVO.subtitleY;
				setChildIndex(subtitle, numChildren - 1);
				TweenLite.to(subtitle, 0.3, {alpha: 1});
			}
		}

		private var playingSubtitle:SubtitleVO;

		private function playSubtitle(useInPreviewSubtitle:Boolean=false):void
		{
			if (useInPreviewSubtitle)
			{
				subtitleReady=false;
				if (subtitle.vo == subtitleVO)
					pc.showVO(subtitleVO, subtitle);
			}
			else if (playingSubtitle == subtitleVO)
			{
				return;
			}

			if (useInPreviewSubtitle || playingSubtitle != subtitleVO)
			{
				if (subtitleVO.background)
					lm.load(pc.getUrl(subtitleVO.background), backGroundLoadedHandler, null, null, null, false, LoadManager.BITMAP);
				if (subtitleVO.frontMask)
					lm.load(pc.getUrl(subtitleVO.frontMask), frontMaskLoadedHandler, null, null, null, false, LoadManager.BITMAP);
				if (subtitleVO.background || subtitleVO.frontMask)
					subtitle.visible=false;
			}
			subtitle.useInPreview=isPreviewEvent ? isPreviewEvent : useInPreviewSubtitle;
			playingSubtitle=subtitleVO;
			subtitle.vo=subtitleVO;
			if (subtitleReady)
				pc.showVO(subtitleVO, subtitle);
		}

		private function getRectangle(arr:Array):Rectangle
		{
			return new Rectangle(arr[0], arr[1], arr[2], arr[3]);
		}

		private function frontMaskLoadedHandler(frontMask:Bitmap):void
		{
			var sc:ScaleBitmap=new ScaleBitmap(frontMask.bitmapData);
			sc.scale9Grid=getRectangle(subtitleVO.frontMaskScalGrid);
			subtitle.frontMask=sc;
		}

		private function backGroundLoadedHandler(background:Bitmap):void
		{
			var sc:ScaleBitmap=new ScaleBitmap(background.bitmapData);
			sc.scale9Grid=getRectangle(subtitleVO.backgroundScaleGrid);
			subtitle.background=sc;
		}

		private var audioPlayer:SoundPlayer;
		private var isPreviewEvent:Boolean;

		private function playEvent(isPreviewEvent:Boolean=false):void
		{
			pausing=false;
			this.isPreviewEvent=isPreviewEvent;
			isPlayingConversation=eventsVO.type == Const.CONVERSATION;
			isPlayingSubtitle=eventsVO.type == Const.SUBTITLE;
			isPlayingGame=eventsVO.type == Const.GAME;
			playlist=eventsVO.subtitles.concat();
			if (eventsVO.audioFile)
				initAudioPlayer();
			if (!isPreviewEvent)
			{
				if (intervalTimer)
				{
					intervalTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
					intervalTimer.stop();
				}

				intervalTimer=new Timer(eventsVO.intervalTime, 1);
				intervalTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			}
			if (isPlayingSubtitle)
			{
				subtitle.vo=null;
				subtitleVO=playlist.shift();
			}
			else if (isPlayingConversation)
			{
				conversationVO=playlist.shift();
			}
			else if (isPlayingGame)
			{
				if (gameTimer)
				{
					gameTimer.stop();
					gameTimer.removeEventListener(TimerEvent.TIMER, gameTimerHandler);
					gameTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, gameOverHandler);
				}
				gameTimer=new Timer(1000, eventsVO.gameVO.totalTime);
				gameTimer.addEventListener(TimerEvent.TIMER, gameTimerHandler);
				gameTimer.addEventListener(TimerEvent.TIMER_COMPLETE, gameOverHandler);
				gameTimer.start();
			}
		}

		protected function gameTimerHandler(event:TimerEvent):void
		{

		}

		protected function gameOverHandler(event:TimerEvent):void
		{

		}

		private var isPlayingGame:Boolean;
		private var isPlayingConversation:Boolean;
		private var isPlayingSubtitle:Boolean;

		protected function onTimerComplete(event:TimerEvent):void
		{
			if (eventsList && eventsList.length)
			{
				eventsVO=eventsList.shift();
				playEvent();
			}
		}

		private function initAudioPlayer():void
		{
			if (!audioPlayer)
			{
				audioPlayer=new SoundPlayer(200);
				audioPlayer.addEventListener("playing", playingHandler);
				audioPlayer.addEventListener("playComplete", playCompleteHandler);
				audioPlayer.autoPlay=true;
			}
			audioPlayer.url=pc.getUrl(eventsVO.audioFile);
			audioPlayer.repeat=eventsVO.repeat;
		}

		protected function playCompleteHandler(event:Event):void
		{
			playEventComplete();
		}

		private var playlist:Array;
		private var eventsList:Array;
		private var c:Container;

		protected function playingHandler(event:DataEvent):void
		{
			var position:Number=parseFloat(event.data);
			if (isPlayingSubtitle && subtitleVO)
			{
				if (subtitleVO.startTime - subtitleVO.effectDuration * 1000 < position && subtitleVO.endTime > position)
				{
					playSubtitle();
				}
				else if (subtitleVO.endTime < position && playlist.length)
				{
					subtitleReady=false;
					subtitleVO=playlist.shift();
					trace('Go to play: ' + subtitleVO.text);
					subtitle.visible=false;
					subtitle.vo=subtitleVO;
				}
				else if (!playlist.length)
				{
					subtitle.visible=false;
				}
			}
			else if (isPlayingConversation && conversationVO)
			{
				subtitleVO=null;
				subtitleReady=false;
				if (conversationVO.startTime - conversationVO.effectDuration * 1000 < position && conversationVO.endTime > position)
				{
					playConversation();
				}
				else if (conversationVO.endTime < position && playlist.length)
				{
					pc.revertAvatar(conversationVO);
					delete avatarDic[conversationVO];
					subtitle.visible=false;
					conversationVO=playlist.shift();
				}
				else if (avatarDic[conversationVO] && !playlist.length)
				{
					delete avatarDic[conversationVO];
					pc.revertAvatar(conversationVO);
					subtitle.visible=false;
					conversationVO=null;
				}
			}
			trace('Playing', position);
		}

		private var avatarDic:Dictionary=new Dictionary();
		private var lm:LoadManager;

		private function playConversation():void
		{
			var a:Avatar=avatarDic[conversationVO] as Avatar;
			if (!a)
			{
				playingAvatar=getAvatar(conversationVO);
				avatarDic[conversationVO]=playingAvatar;
			}
		}

		private function playEventComplete():void
		{
			if (isPlayingSubtitle)
				subtitle.visible=false;
			if (!isPreviewEvent)
			{
				if (eventsList && eventsList.length)
					intervalTimer.start();
				else if (!currentPageVO.forcePause)
					nextPage();
				else
					pausing=true;
			}
		}

		public function prePage():void
		{
			if (playingPage > 1)
				play(playingPage - 1);
		}

		public function nextPage():void
		{
			if (playingPage < vo.pages.length - 1)
				play(playingPage + 1);
		}

		public function show(page:int):void
		{
			if (!vo.pages || page == currentPageNum)
				return;
			currentPageVO=vo.pages[page];
			hotAreaContainer.initHotAreas(currentPageVO.hotAreas);
			subtitle.visible=false;
			currentPageNum=page;
			trace('show page:', page);
			var image:Image;
			if (currentPage)
			{
				setChildIndex(currentPage, numChildren - 1);
				TweenLite.to(currentPage, 1, {alpha: 0, onComplete: clearCurrentPage, onCompleteParams: [currentPage]});
			}
			fillContent();
		}

		private function swfLoadedHandler(contentBase:ContentBase):void
		{
			contentBase.initialize(width, height);
			addChildAt(contentBase, 0);
			if (!currentPageVO.states)
				currentPageVO.states=contentBase.states;
			currentPage=contentBase;
			judgeContent(contentBase);
			showCurrentPage();
		}

		private function showCurrentPage():void
		{
			currentPage.alpha=0;
			currentPage.visible=true;
			TweenLite.to(currentPage, 1, {alpha: 1});
		}

		private function clearCurrentPage(page:DisplayObject):void
		{
			var image:Image;
			var content:ContentBase;
			if (currentPageVO.isSwf())
			{
				content=page as ContentBase;
				content.dispose();
				removeChild(content);
			}
			else
			{
				image=page as Image;
				image.source=null;
				image.visible=false;
				image.alpha=1;
			}
		}

		private function fillContent():void
		{
			if (currentPageVO.isSwf())
			{
				lm.load(pageContentURL, swfLoadedHandler, null, null, null, false, LoadManager.SWF);
			}
			else
			{
				var image:Image;
				image=currentPage != centerImage ? centerImage : otherImage;
				image.forceAutoFill=true;
				image.source=pageContentURL;
				currentPage=image;
			}
		}

		private function get pageContentURL():String
		{
			return pc.getUrl(currentPageVO.content);
		}

		public function get vo():BookVO
		{
			return _vo;
		}

		public function set vo(value:BookVO):void
		{
			_vo=value;
			pc.vo=value;
		}

		private var contentBase:ContentBase;

		override protected function init():void
		{
			initImages();
			initSubtitle();
			initHotAreaContainer();
			if (pc.useByCreator)
			{
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				enableMask=true;
			}
			else
			{
				pc.enableDrag=true;
			}
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
		}

		private function initHotAreaContainer():void
		{
			hotAreaContainer=new HotAreaContainer(width, height);
			hotAreaContainer.addEventListener("clickHotArea", clickHotAreaHandler);
			addChild(hotAreaContainer);
		}

		protected function clickHotAreaHandler(event:Event):void
		{
			var vo:HotAreaVO=hotAreaContainer.clickedVO;
			if (vo.type == Const.FIND_WRONG)
			{
				if (pausing)
				{

				}
			}
		}

		public function setPainter(painter:Sprite):void
		{
			this.painter=painter;
		}

		private var dragBound:Rectangle;

		protected function stageMouseDownHandler(event:MouseEvent):void
		{
			if (enableDragContent && pc.enableDrag)
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
				stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
				currentPage.startDrag(false, dragBound);
			}
		}

		protected function stageMouseMoveHandler(event:MouseEvent):void
		{
			if (painter)
			{
				painter.x=currentPage.x;
				painter.y=currentPage.y;
			}
			hotAreaContainer.x=currentPage.x;
			hotAreaContainer.y=currentPage.y;
		}

		protected function stageMouseUpHandler(event:MouseEvent):void
		{
			currentPage.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
		}

		protected function keyDownHandler(event:KeyboardEvent):void
		{
			if (!currentPageVO)
				return;
			if (event.keyCode == Keyboard.LEFT)
				prePage();
			else if (event.keyCode == Keyboard.RIGHT)
				nextPage();
		}

		override protected function dispose():void
		{
			stopPreview();
			super.dispose();
		}

		public function stopPreview():void
		{
			if (audioPlayer)
				audioPlayer.stop();
			if (intervalTimer)
				intervalTimer.stop();
			clearPreview();
			if (subtitle)
			{
				subtitle.visible=false;
				subtitle.vo=null;
			}
			pc.playingVO=null;
			currentPageVO=null;
		}

		private function initImages():void
		{
			centerImage=new Image();
			centerImage.addEventListener(Event.COMPLETE, imageCompleteHandler);
			addChild(centerImage);
			otherImage=new Image();
			otherImage.addEventListener(Event.COMPLETE, imageCompleteHandler);
			otherImage.visible=false;
			addChild(otherImage);
		}

		protected function imageCompleteHandler(event:Event):void
		{
			judgeContent(event.target as DisplayObject);
		}

		private function judgeContent(target:DisplayObject):void
		{
			if (target.width != width || target.height != height)
			{
				enableDragContent=true;
				target.x=width / 2 - target.width / 2;
				target.y=height / 2 - target.height / 2;
				var x:Number=target.width > width ? width - target.width : 0;
				var y:Number=target.height > height ? height - target.height : 0;
				var w:Number=target.width > width ? target.width - width : width - target.width;
				var h:Number=target.height > height ? target.height - height : height - target.height;
				dragBound=new Rectangle(x, y, w, h);
			}
			else
			{
				enableDragContent=false;
				target.x=target.y=0;
			}
			if (painter)
			{
				painter.x=target.x;
				painter.y=target.y;
				painter.width=target.width;
				painter.height=target.height;
			}
			hotAreaContainer.x=target.x;
			hotAreaContainer.y=target.y;
			hotAreaContainer.setSize(target.width, target.height);
			if (currentPage is Image)
				trace('Content: ' + (currentPage as Image).source);
			trace(target.width + '-' + target.height + '&' + target.x + '-' + target.y);
			showCurrentPage();
		}

		private function initSubtitle():void
		{
			subtitle=new Subtitle();
			if (pc.useByCreator)
				subtitle.fontFamily='Microsoft YaHei';
			subtitle.visible=false;
			subtitle.addEventListener(ResizeEvent.RESIZE, subtitleResizedHandler);
			addChild(subtitle);
		}

		protected function subtitleResizedHandler(event:ResizeEvent):void
		{
			TweenLite.killDelayedCallsTo(showSubtitle);
			TweenLite.delayedCall(0.1, showSubtitle);
		}

		private var subtitleReady:Boolean;
		private var enableDragContent:Boolean;
		private var painter:Sprite;
		private var hotAreaContainer:HotAreaContainer;

		/**
		 * 当前页播放完成并处于暂停状态
		 */
		private var pausing:Boolean;
		private var gameTimer:Timer;

		private function showSubtitle():void
		{
			if (subtitle.width && subtitle.height && !conversationVO && subtitleVO)
			{
				if (subtitleVO.background && subtitleVO.frontMask)
				{
					if (subtitle.background && subtitle.frontMask)
						subtitleReady=true;
				}
				else if (subtitleVO.background && subtitle.background)
				{
					subtitleReady=true;
				}
				else if (subtitleVO.frontMask && subtitle.frontMask)
				{
					subtitleReady=true;
				}
				else if (!subtitleVO.background && !subtitleVO.frontMask)
				{
					subtitleReady=true;
				}
				if (subtitleReady && playingSubtitle == subtitleVO)
					pc.showVO(subtitleVO, subtitle);
			}
		}

//************************定位内容		

		public function positionContent(vo:Object):void
		{
			conversationVO=vo as ConversationVO;

			if (conversationVO)
			{
				var a:Avatar=positionTargets[vo];
				if (!a)
				{
					a=new Avatar(conversationVO);
					a.addEventListener(Event.COMPLETE, positionAvatarComplete);
					a.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
					addChild(a);
					positionTargets[vo]=a;
				}
				else
				{
					a.vo=conversationVO;
				}

				if (settingStartPosition)
				{
					a.x=conversationVO.avatarStartX;
					a.y=conversationVO.avatarStartY;
				}
				else
				{
					a.x=conversationVO.avatarX;
					a.y=conversationVO.avatarY;
				}
			}
		}

		protected function positionAvatarComplete(event:Event):void
		{
			event.currentTarget.removeEventListener(Event.COMPLETE, positionAvatarComplete);
			stopPreview();
		}

		protected function mouseDownHandler(event:MouseEvent):void
		{
			var a:Avatar=event.currentTarget as Avatar;
			currentAvatar=a;
			a.startDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		protected function mouseUpHandler(event:MouseEvent):void
		{
			currentAvatar.stopDrag();
			currentAvatar.updatePosition(settingStartPosition);
			currentAvatar=null;
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		public function scaleContent(vo:ConversationVO):void
		{
			var a:Avatar=positionTargets[vo];
			if (a)
				a.scaleX=a.scaleY=vo.avatarScale;
		}

		private function clearAvatars(dic:Dictionary):void
		{
			for (var key:Object in dic)
			{
				var a:Avatar=dic[key];
				if (a && a.parent)
					removeChild(a);
				delete dic[key];
			}
		}

		public function clearPostionContents():void
		{
			clearAvatars(positionTargets);
		}
	}
}
