package views.book
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.MotionBlurPlugin;
	import com.greensock.plugins.ShakeEffect;
	import com.greensock.plugins.TransformAroundCenterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.pamakids.components.base.Container;
	import com.pamakids.components.base.UIComponent;
	import com.pamakids.components.controls.Button;
	import com.pamakids.components.controls.Image;
	import com.pamakids.components.controls.ProgressBar;
	import com.pamakids.components.controls.ScaleBitmap;
	import com.pamakids.components.controls.SoundPlayer;
	import com.pamakids.content.ContentBase;
	import com.pamakids.events.ResizeEvent;
	import com.pamakids.manager.LoadManager;
	import com.pamakids.manager.PopupManager;
	import com.pamakids.util.CloneUtil;

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
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	import controller.PC;

	import model.consts.Const;
	import model.content.BookVO;
	import model.content.ConversationVO;
	import model.content.EventsVO;
	import model.content.HotAreaVO;
	import model.content.PageVO;
	import model.content.SubtitleVO;
	import model.games.GameVO;

	import views.components.ElasticButton;
	import views.game.GameResultBox;
	import views.hotArea.HotAreaContainer;

	public class BookPlayer extends Container
	{

		public function BookPlayer(width:Number, height:Number)
		{
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

		private var currentPageVO:PageVO;
		private var currentPageNum:int=-1;
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

		private var playing:Boolean;

		public function play(page:int=0):void
		{
			if (playing)
				return;
			playing=true;
			clearPostionContents();
			stopPreview();
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
				if (playingAvatar.parent)
					removeChild(playingAvatar);
				playingAvatar=null;
			}
			clearAvatars(avatarDic);
			clearGameListeners();
			clearHideAlertTimer();
		}

		public function previewContent(vo:Object, pageVO:PageVO=null):void
		{
			subtitleVO=vo as SubtitleVO;
			conversationVO=vo as ConversationVO;
			stopPreview();
			currentPageVO=pageVO;
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
					pc.showVO(conversationVO, playingAvatar, avatarShownHandler);
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
			pc.showVO(conversationVO, event.currentTarget as Avatar, avatarShownHandler, [conversationVO]);
		}

		private function avatarShownHandler(vo:ConversationVO):void
		{
			handleAerlt(vo);
			showAvatarSubtitle();
		}

		private function showAvatarSubtitle():void
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
			this.isPreviewEvent=isPreviewEvent;
			isPlayingConversation=eventsVO.type == Const.CONVERSATION;
			isPlayingSubtitle=eventsVO.type == Const.SUBTITLE;
			isPlayingGame=eventsVO.type == Const.GAME;
			if (!isPlayingGame)
				playlist=eventsVO.subtitles.concat();
			pausing=isPlayingGame;
			if (eventsVO.audioFile)
				playAudio();
			if (!isPreviewEvent)
			{
				if (intervalTimer)
				{
					intervalTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
					intervalTimer.stop();
				}
				if (eventsVO.intervalTime)
				{
					intervalTimer=new Timer(eventsVO.intervalTime, 1);
					intervalTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
				}
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
				playGame();
			}
		}

		private function playGame():void
		{
			stopGameTimer();
			initGameControls();
			progressBar.progress=1;
			progressBar.visible=true;
			pauseButton.visible=true;
			if (gameTimer)
			{
				gameTimer.removeEventListener(TimerEvent.TIMER, gameTimerHandler);
				gameTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, gameOverHandler);
			}
			gameTimer=new Timer(1000, eventsVO.gameVO.totalTime);
			gameTimer.addEventListener(TimerEvent.TIMER, gameTimerHandler);
			gameTimer.addEventListener(TimerEvent.TIMER_COMPLETE, gameOverHandler);
			gameTimer.start();
			if (gameVO.type == Const.FIND_WRONG)
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, wrongClickHandler);
				initFoundGameData();
			}
			initHotAreas();
		}

		private function initFoundGameData():void
		{
			foundItem=[];
			tobeFoundedItems=[];
			var arr:Array=currentPageVO.hotAreas;
			if (arr && arr.length)
			{
				for each (var ho:HotAreaVO in arr)
				{
					if (ho.type == Const.FIND_WRONG)
						tobeFoundedItems.push(ho);
				}
			}
		}

		private var tobeFoundedItems:Array;

		private function hideGameControls():void
		{
			if (progressBar)
				progressBar.visible=false;
			if (pauseButton)
				pauseButton.visible=false;
			clearResultBox();
			if (foundItem)
			{
				foundItem.length=0;
				foundItem=null;
			}
		}

		private function initGameControls():void
		{
			initProgressBar();
			initPauseButton();
		}

		private function initPauseButton():void
		{
			if (!pauseButton)
			{
				pauseButton=new ElasticButton('pauseButton');
				pauseButton.addEventListener(MouseEvent.MOUSE_DOWN, pauseGameHandler);
				pauseButton.x=20;
				pauseButton.y=20;
				pauseButton.visible=false;
				contentContainer.addChild(pauseButton);
			}
		}

		protected function pauseGameHandler(event:MouseEvent=null):void
		{
			if (event)
				event.stopImmediatePropagation();
			pauseGame();
			initGameResultBox(GameResultBox.PAUSE);
			playAlert(gameVO.pauseAlert);
		}

		private function pauseGame():void
		{
			if (gameTimer.running)
				gameTimer.stop();
			audioPlayer.pause();
		}

		public function initGameResultBox(state:String, life:int=0):void
		{
			if (gameResult)
				clearResultBox();
			gameResult=new GameResultBox();
			gameResult.state=state;
			gameResult.life=life;
			gameResult.addEventListener("resume", resumeGameHandler);
			gameResult.addEventListener("playAgain", playAgainHandler);
			gameResult.addEventListener("nextPage", nextPageHandler);
			PopupManager.popup(gameResult);
		}

		protected function nextPageHandler(event:Event):void
		{
			clearGame();
			clearResultBox();
			nextPage();
		}

		private function clearGame():void
		{
			clearGameListeners();
			hideGameControls();
			stopGameTimer();
		}

		protected function playAgainHandler(event:Event):void
		{
			clearResultBox();
			playGame();
		}

		protected function resumeGameHandler(event:Event):void
		{
			clearResultBox();
			if (audioPlayer.paused)
				audioPlayer.play();
			gameTimer.start();
		}

		public function clearResultBox():void
		{
			if (gameResult)
			{
				PopupManager.removePopup(gameResult);
				gameResult.removeEventListener("playAgain", playAgainHandler);
				gameResult.removeEventListener("nextPage", nextPageHandler);
				gameResult.removeEventListener("resme", resumeGameHandler);
				gameResult=null;
				hideAlertHandler();
			}
		}

		private function clearGameListeners():void
		{
			if (gameVO && gameVO.type == Const.FIND_WRONG)
				stage.removeEventListener(MouseEvent.MOUSE_UP, wrongClickHandler);
		}

		protected function wrongClickHandler(event:MouseEvent):void
		{
			TweenLite.killDelayedCallsTo(playWrongAlert);
			TweenLite.delayedCall(0.2, playWrongAlert);
		}

		private function playWrongAlert():void
		{
			if (gameTimer.running && !clickedHotArea)
				playAlert(gameVO.wrongAlert);
			if (clickedHotArea)
				clickedHotArea=null;
		}

		private function get gameVO():GameVO
		{
			return eventsVO ? eventsVO.gameVO : null;
		}

		private function stopGameTimer():void
		{
			if (gameTimer)
			{
				gameTimer.stop();
				gameTimer.removeEventListener(TimerEvent.TIMER, gameTimerHandler);
				gameTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, gameOverHandler);
				gameTimer=null;
			}
		}

		private var progressBar:ProgressBar;

		private function initProgressBar():void
		{
			if (!progressBar)
			{
				progressBar=new ProgressBar(580);
				progressBar.x=width / 2 - progressBar.width / 2;
				progressBar.y=28;
				addChild(progressBar);
			}
		}

		protected function gameTimerHandler(event:TimerEvent):void
		{
			progressBar.progress=(1 - gameTimer.currentCount / gameTimer.repeatCount);
		}

		protected function gameOverHandler(event:TimerEvent):void
		{
			trace('Game Over');
			pauseGame();
			var life:int;
			if (gameVO.type == Const.FIND_WRONG)
				life=Math.round((foundItem.length / tobeFoundedItems.length) * gameVO.totalLife);
			if (life)
			{
				initGameResultBox(GameResultBox.WIN, life);
				playAlert(gameVO.winAlert);
			}
			else
			{
				initGameResultBox(GameResultBox.FAILURE);
				playAlert(gameVO.failureAlert);
			}
		}

		/**
		 * 播放提示
		 */
		private function playAlert(url:String):void
		{
			if (!url || playingAlertDic[url])
				return;
			trace('playing alert', url, playingAlertDic[url]);
			if (playingAlert)
				hideAlertHandler();
			playingAlertUrl=url;
			playingAlertDic[url]=true;
			lm.load(pc.getUrl(url), alertLoadedHandler);
		}

		private var playingAlertUrl:String;
		private var playingAlertDic:Dictionary=new Dictionary();
		private var playingAlert:ConversationVO;

		private function alertLoadedHandler(byteArray:ByteArray):void
		{
			if (byteArray.position)
				byteArray.position=0;
			var alert:ConversationVO=CloneUtil.convertObject(byteArray.readObject(), ConversationVO);
			conversationVO=alert;
			if (alert.avatar)
				playingAvatar=getAvatar(alert);
			else
				delete playingAlertDic[playingAlertUrl];
			if (!alert.soundPlayTime)
				audioEffectPlayer.url=pc.getUrl(alert.sound);
		}

		private var hideAlertTimer:Timer;

		private function handleAerlt(vo:ConversationVO):void
		{
			if (!vo.type)
				return;
			if (vo.soundPlayTime)
				audioEffectPlayer.url=pc.getUrl(vo.sound);
			playingAlert=vo;
			if (vo.hideAfterMouseDown)
			{
				stage.addEventListener(MouseEvent.MOUSE_DOWN, hideAlertHandler);
			}
			if (vo.autoHideTime)
			{
				clearHideAlertTimer();
				hideAlertTimer=new Timer(1000, vo.autoHideTime);
				hideAlertTimer.addEventListener(TimerEvent.TIMER_COMPLETE, hideAlertHandler);
				hideAlertTimer.start();
			}
		}

		private function clearHideAlertTimer():void
		{
			if (hideAlertTimer)
			{
				hideAlertTimer.stop();
				hideAlertTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, hideAlertHandler);
				hideAlertTimer=null;
			}
		}

		protected function hideAlertHandler(event:Event=null):void
		{
			if (!playingAlert)
				return;
			if (playingAlert.hideAfterMouseDown)
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, hideAlertHandler);
			clearHideAlertTimer();
			if (playingAlert.avatar)
				pc.revertAvatar(playingAlert, revertedHandler, [playingAlertUrl]);
			else
				delete playingAlertDic[playingAlertUrl];
			if (audioEffectPlayer.playing)
				audioEffectPlayer.stop();
			playingAlert=null;
			subtitle.visible=false;
		}

		private function revertedHandler(url:String):void
		{
			delete playingAlertDic[url];
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

		private function playAudio():void
		{
			audioPlayer.url=pc.getUrl(eventsVO.audioFile);
			audioPlayer.repeat=eventsVO.repeat;
		}

		private var audioEffectPlayer:SoundPlayer;

		private function initAudioPlayer():void
		{
			if (!audioPlayer)
			{
				audioPlayer=new SoundPlayer(200);
				audioPlayer.addEventListener("playing", playingHandler);
				audioPlayer.addEventListener("playComplete", playCompleteHandler);
				audioPlayer.autoPlay=true;
			}

			if (!audioEffectPlayer)
			{
				audioEffectPlayer=new SoundPlayer();
				audioEffectPlayer.autoPlay=true;
			}
		}

		protected function playCompleteHandler(event:Event):void
		{
			if (!isPlayingGame)
				playEventComplete();
		}

		private var playlist:Array;
		private var eventsList:Array;
		private var c:Container;

		protected function playingHandler(event:DataEvent):void
		{
			if (isPlayingGame)
				return;
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
			if (currentPageNum > 1)
				play(currentPageNum - 1);
		}

		public function nextPage():void
		{
			if (currentPageNum < vo.pages.length - 1)
				play(currentPageNum + 1);
		}

		public function show(page:int):void
		{
			if (!vo.pages || (page == currentPageNum && page))
				return;
			currentPageVO=vo.pages[page];
			if (playing)
			{
				hotAreaContainer.initHotAreas(currentPageVO.hotAreas);
				contentContainer.setChildIndex(hotAreaContainer, contentContainer.numChildren - 1);
			}
			subtitle.visible=false;
			clearGame();
			currentPageNum=page;
			trace('show page:', page);
			var image:Image;
			if (currentPage)
			{
				contentContainer.setChildIndex(currentPage, contentContainer.numChildren - 1);
				currentPage.alpha=1;
				TweenLite.to(currentPage, 1, {alpha: 0, onComplete: clearCurrentPage, onCompleteParams: [currentPage]});
			}
			fillContent();
		}

		private function initHotAreas():void
		{
			if (!playing)
			{
				hotAreaContainer.initHotAreas(currentPageVO.hotAreas);
				contentContainer.setChildIndex(hotAreaContainer, contentContainer.numChildren - 1);
			}
		}

		private function swfLoadedHandler(contentBase:ContentBase):void
		{
			contentBase.initialize(width, height);
			contentContainer.addChildAt(contentBase, 0);
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
				contentContainer.removeChild(content);
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
				currentPage=image;
				if (image.source == pageContentURL)
				{
					showCurrentPage();
					judgeContent(image);
				}
				else
				{
					image.source=pageContentURL;
				}
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
		private var contentContainer:UIComponent;

		override protected function init():void
		{
			contentContainer=new Container(width, height, false, true);
			addChild(contentContainer);
			var popupLayer:UIComponent=new UIComponent(width, height);
			addChild(popupLayer);
			PopupManager.parent=popupLayer;
			initImages();
			initSubtitle();
			initHotAreaContainer();
			initAudioPlayer();
			if (pc.useByCreator)
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			else
				pc.enableDrag=true;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
		}

		private function initHotAreaContainer():void
		{
			hotAreaContainer=new HotAreaContainer(width, height);
			hotAreaContainer.addEventListener("clickHotArea", clickHotAreaHandler);
			contentContainer.addChild(hotAreaContainer);
		}

		private var clickedHotArea:HotAreaVO;
		private var foundItem:Array;

		protected function clickHotAreaHandler(event:Event):void
		{
			var vo:HotAreaVO=hotAreaContainer.clickedVO;
			if (vo.type == Const.FIND_WRONG)
			{
				clickedHotArea=vo;
				if (foundItem.indexOf(clickedHotArea) == -1)
					foundItem.push(clickedHotArea);
				if (foundItem.length == tobeFoundedItems.length)
				{
					gameOverHandler(null);
				}
				if (pausing)
				{
					trace(vo.type);
				}
			}
		}

		private function playAudioEffect(url:String):void
		{
			if (!url)
				return;
			if (!audioEffectPlayer)
			{
				audioEffectPlayer=new SoundPlayer();
				audioEffectPlayer.autoPlay=true;
			}
			audioEffectPlayer.url=pc.getUrl(url);
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
			playing=false;
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
			stopGameTimer();
			clearGame();
			hotAreaContainer.clear();
			clearPostionContents();
		}

		private function initImages():void
		{
			centerImage=new Image();
			centerImage.addEventListener(Event.COMPLETE, imageCompleteHandler);
			contentContainer.addChild(centerImage);
			otherImage=new Image();
			otherImage.addEventListener(Event.COMPLETE, imageCompleteHandler);
			otherImage.visible=false;
			contentContainer.addChild(otherImage);
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
			positionPinter(target);
			hotAreaContainer.x=target.x;
			hotAreaContainer.y=target.y;
			hotAreaContainer.setSize(target.width, target.height);
			if (currentPage is Image)
				trace('Content: ' + (currentPage as Image).source);
			trace(target.width + '-' + target.height + '&' + target.x + '-' + target.y);
			showCurrentPage();
		}

		public function positionPinter(target:DisplayObject):void
		{
			if (painter)
			{
				if (!target)
					target=currentPage;
				painter.x=target.x;
				painter.y=target.y;
				painter.width=target.width;
				painter.height=target.height;
			}
		}

		private function initSubtitle():void
		{
			subtitle=new Subtitle();
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
		private var pauseButton:Button;
		private var gameResult:GameResultBox;

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
					pc.showVO(subtitleVO, subtitle, subtitleShownHandler);
			}
		}

		private function subtitleShownHandler():void
		{
			trace(subtitle.x, subtitle.y, subtitle.visible, subtitle.alpha);
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
