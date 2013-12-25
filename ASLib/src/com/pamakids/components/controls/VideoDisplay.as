package com.pamakids.components.controls
{
	import com.greensock.TweenLite;
	import com.pamakids.components.base.Container;
	import com.pamakids.utils.DPIUtil;

	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StageVideoEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.StageVideo;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	[Event(name="played", type="flash.events.Event")]
	/**
	 * 视频播放
	 */
	public class VideoDisplay extends Container
	{
		public static const BUFFERING:String="buffering";
		public static const BUFFER_FULL:String="bufferFull";
		public static const PLAYING:String='playing';
		public static const REPLAY:String="replay";
		public static const PLAYED:String="played";
		public static const START:String="NetStream.Play.Start";
		private static const EMPTY:String="NetStream.Buffer.Empty";
		private static const FLUSH:String="NetStream.Buffer.Flush";
		private static const FULL:String="NetStream.Buffer.Full";
		private static const NET_CONNECTION_SUCCESS:String="NetConnection.Connect.Success";
		private static const STREAM_NOT_FOUND:String="NetStream.Play.StreamNotFound";

		public function VideoDisplay(w:Number, h:Number)
		{
			scaleNumber=DPIUtil.getDPIScale();
			super(w * scaleNumber, h * scaleNumber, false);
//			initTimer();
		}

		override public function set x(value:Number):void
		{
			super.x=value * scaleNumber;
		}

		public var bufferPercent:Number=0.0;
		public var playHead:Number;

		private var _autoPlay:Boolean;

		private var _autoRepeat:Boolean;

		private var _bufferTime:Number=0;
		private var _client:Object;

		private var _duration:Number;
		private var _orignalHeight:Number;

		private var _orignalWidth:Number;

		private var _repeatStart:Number=0.0;
		private var _soundTransform:SoundTransform;

		private var _url:String;
		private var bufferBytesPercent:Number;

		private var flushed:Boolean;
		private var hasFulled:Boolean;
		private var nc:NetConnection;
		private var normalMask:Boolean=true;

		private var ns:NetStream;
		public var paused:Boolean;
		private var played:Boolean;
		private var timer:Timer;
		private var video:Video;
		private var videoMask:Container;
		private var pausedByBuffer:Boolean;
		private var seeked:Boolean;
		private var resumed:Boolean;
		private var resumTime:Number;
		private var callingJudgetSeek:Boolean;

		public function get autoPlay():Boolean
		{
			return _autoPlay;
		}

		public function set autoPlay(value:Boolean):void
		{
			_autoPlay=value;
		}

		public function get autoRepeat():Boolean
		{
			return _autoRepeat;
		}

		public function set autoRepeat(value:Boolean):void
		{
			_autoRepeat=value;
		}

		public function get bufferTime():Number
		{
			return _bufferTime;
		}

		public function set bufferTime(value:Number):void
		{
			_bufferTime=value;
		}

		public function get duration():Number
		{
			return _duration;
		}

		public function set duration(value:Number):void
		{
			_duration=value;
		}


		private var initTime:Number;

		public function onMetaData(metadata:Object):void
		{
			initTime=getTimer();
			duration=parseFloat(metadata.duration) * 1000;
			bufferBytesPercent=bufferTime / duration;
			orignalWidth=parseFloat(metadata.width);
			trace(duration, orignalWidth, orignalHeight);
			orignalHeight=parseFloat(metadata.height);
		}

		public function onPlayStatus(... arg):void
		{
		}

		public function onXMPData(... arg):void
		{
		}

		public function get orignalHeight():Number
		{
			return _orignalHeight;
		}

		public function set orignalHeight(value:Number):void
		{
			_orignalHeight=value;
		}


		public function get orignalWidth():Number
		{
			return _orignalWidth;
		}

		public function set orignalWidth(value:Number):void
		{
			_orignalWidth=value;
		}

		public function pause():void
		{
			if (paused)
				return;
			if (ns)
				ns.pause();
			paused=true;
			if (timer)
			{
				timer.stop();
			}
		}

		private function onSecurityErrorHandler(event:SecurityErrorEvent):void
		{
		}

		protected function onCuePoint(item:Object):void
		{
		}

		protected function onBWDone():void
		{
		}

		private function onNetStatus(evt:NetStatusEvent):void
		{
			switch (evt.info.code)
			{
				case "NetConnection.Connect.Success":
					initNetStream();
					nc.client={};

					var v:Vector.<StageVideo>=stage.stageVideos;
					if (v.length >= 1)
					{
						stageVideo=v[0];
						stageVideo.viewPort=new Rectangle(x, y, width, height);
						stageVideo.attachNetStream(ns);
						trace('stage video');
					}
					else
					{
						initVideo();
					}

					if (url)
						ns.play(url);

					break;
				case "NetStream.Publish.BadName":
					break;
				default:
					break;
			}
		}

		public function play(url:String, start:Number=-2, len:Number=-1, reset:Object=1):void
		{
			if (!timer)
				initTimer();
			this._url=url;
			if (stage && !nc)
				initNetConnection();
		}


		protected function onRender(event:StageVideoEvent):void
		{
			sv.viewPort=new Rectangle(0, 0, width, height);
		}

		public function get repeatStart():Number
		{
			return _repeatStart;
		}

		public function set repeatStart(value:Number):void
		{
			_repeatStart=value;
		}

		public function resume():void
		{
			if (!paused)
			{
				return;
			}
			paused=false;
			if (ns)
				ns.resume();
			resumed=true;
			resumTime=ns.time;
			TweenLite.killDelayedCallsTo(judgeSeekToResume);
			TweenLite.delayedCall(1, judgeSeekToResume);
			if (timer)
				timer.start();
		}

		public function seek(time:Number):void
		{
			if (ns)
				ns.seek(time);
		}

		public function setBlackMask():void
		{
			if (!normalMask)
				return;
			normalMask=false;
			videoMask.alpha=0.2;
		}

		public function setNormalMask():void
		{
			if (normalMask)
				return;
			normalMask=true;
			videoMask.alpha=0.1;
		}

		//		override public function setSize(width:Number, height:Number):void
		//		{
		//			super.setSize(width, height);
		//			if (videoMask)
		//				videoMask.setSize(width, height);
		//			resizeVideo();
		//			positionLoading();
		//		}

		public function setStreamVolume(value:Number):void
		{
			_soundTransform.volume=value;
			if (ns)
				ns.soundTransform=_soundTransform;
		}

		public function stop():void
		{
			resetVars();
			if (ns)
			{
				ns.close();
				ns.removeEventListener(NetStatusEvent.NET_STATUS, netStreamStatusHandler);
				ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandler);
				ns=null;
			}
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			if (_url == value)
				return;
			_url=value;
			if (_autoPlay)
				play(value);
		}

		protected function errorHandler(event:AsyncErrorEvent):void
		{
		}

		override protected function onStage(e:Event):void
		{
			super.onStage(e);
			if (url)
				initNetConnection();
		}

		private function initLoading():void
		{
			positionLoading();
		}

		private function initNetConnection():void
		{
//			nc=new NetConnection();
//			nc.client=new Object(); //不需要函数回调
//			nc.connect(null);
//			nc.addEventListener(NetStatusEvent.NET_STATUS, ncNetStatusHandler);
//			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandler);
			nc=new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);
			nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler, false, 0, true);
			nc.connect(null);
		}

		private function initNetStream():void
		{
			if (ns)
				return;
			trace('init ns');
			ns=new NetStream(nc);
			ns.bufferTime=bufferTime;
			ns.client=this;
			ns.addEventListener(NetStatusEvent.NET_STATUS, netStreamStatusHandler);
			ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandler);
		}

		private function initTimer():void
		{
			timer=new Timer(300);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
		}

		private function initVideo():void
		{
			video=new Video(width, height);
			video.smoothing=true;
			addChild(video);
			trace('normal video');
		}

		override protected function dispose():void
		{
			trace('dispoed');
			if (stageVideo)
				stageVideo.attachNetStream(null);
			ns.dispose();
		}

		private function inttVideoMask():void
		{
			videoMask=new Container(width, height);
			videoMask.alpha=0.1;
			videoMask.mouseChildren=false;
			videoMask.mouseEnabled=false;
			addChild(videoMask);
		}

		private function ncNetStatusHandler(event:NetStatusEvent):void
		{
			switch (event.info.code)
			{
				case NET_CONNECTION_SUCCESS:
					initNetStream();

					video.attachNetStream(ns);
					ns.play(url);
					break;
			}
			nc.removeEventListener(NetStatusEvent.NET_STATUS, ncNetStatusHandler);
			nc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandler);
		}

		private function netStreamStatusHandler(event:NetStatusEvent):void
		{
			trace(event.info.code, getTimer() - initTime, duration);
			switch (event.info.code)
			{
				case FULL:
					hasFulled=true;
					dispatchEvent(new Event(BUFFER_FULL));
					//					if (pausedByBuffer)
					//					{
					//						resume();
					//						pausedByBuffer=false;
					//					}
					playedHandler();
					break;
				case START:
					if (!timer.running && !paused)
						timer.start();
					dispatchEvent(new Event(START));
					break;
				case FLUSH:
					flushed=true;
					playedHandler();
					break;
				case EMPTY:
					playedHandler();
					break;
			}
		}

		private function playedHandler():void
		{
			if (getTimer() - initTime < duration)
				return;
			trace('played', getTimer() - initTime, duration);
			if (autoRepeat)
			{
				dispatchEvent(new Event(REPLAY));
				seeked=true;
				ns.seek(repeatStart);
			}
			else
			{
				dispatchEvent(new Event(PLAYED));
			}
		}

		private function nsProgressHandler(event:ProgressEvent):void
		{
		}

		private function onTimer(event:TimerEvent):void
		{
			if (!hasFulled)
			{
				if (!bufferBytesPercent)
					bufferBytesPercent=5 / 30;
				try
				{
					bufferPercent=ns.bytesLoaded / (ns.bytesTotal * bufferBytesPercent);
					if (bufferPercent >= 1)
						bufferPercent=0.99;
					dispatchEvent(new Event(BUFFERING));
				}
				catch ($err:Error)
				{
					dispatchEvent(new Event(PLAYED));
				}
				return;
			}
			playHead=ns.time;
			dispatchEvent(new Event(PLAYING));
		}

		private var callTime:int;
		private var sv:StageVideo;
		private var scaleNumber:Number;
		private var stageVideo:StageVideo;

		private function judgeSeekToResume():void
		{
			if (ns.time - resumTime < 1)
				ns.seek(ns.time);
		}

		private function positionLoading():void
		{
			//			if (loading)
			//			{
			//				loading.x=(width - loading.width) / 2;
			//				loading.y=(height - loading.height) / 2;
			//			}
		}

		private function resetVars():void
		{
			seeked=false;
			flushed=false;
			paused=false;
			hasFulled=false;
			playHead=0;
			if (timer)
			{
				timer.stop();
			}
		}

		private function resizeVideo():void
		{
			if (video)
			{
				video.width=width;
				video.height=height;
			}
		}
	}
}
