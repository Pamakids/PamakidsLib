package com.pamakids.components.controls
{
	import com.greensock.TweenLite;

	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	/**
	 * 声音播放器, 不包含视觉元素.
	 * @author mani
	 */
	[Event(name="playing", type="flash.events.DataEvent")]
	[Event(name="playComplete", type="flash.events.Event")]
	[Event(name="error", type="flash.events.DataEvent")]
	public class SoundPlayer extends EventDispatcher
	{

		public static const PLAYING:String="playing";
		public static const PLAY_COMPLETE:String="playComplete";

		public function SoundPlayer(intervalTime:Number=0)
		{
			this.internalTime=intervalTime;
			initSound();
		}

		private var _muted:Boolean;

		private var _autoPlay:Boolean;

		private var _repeat:Boolean;

		private var _url:String;

		private var currentPosition:Number; //当前播放位置

		public var playing:Boolean;

		private var sound:Sound;

		private var soundChannel:SoundChannel;

		private var soundTransform:SoundTransform;

		private var _internalTime:Number;

		/**
		 * 派发playing事件的间隔时间
		 * @return
		 */
		public function get internalTime():Number
		{
			return _internalTime;
		}

		private var internalTimer:Timer;

		public function set internalTime(value:Number):void
		{
			_internalTime=value;
			initIntervalTimer();
		}

		private function initIntervalTimer():void
		{
			stopInternalTimer();
			internalTimer=new Timer(internalTime);
			internalTimer.addEventListener(TimerEvent.TIMER, onTimer);
			internalTimer.start();
		}

		private function stopInternalTimer():void
		{
			if (internalTimer)
			{
				internalTimer.stop();
				internalTimer.removeEventListener(TimerEvent.TIMER, onTimer);
			}
		}

		protected function onTimer(event:TimerEvent):void
		{
			if (soundChannel)
				dispatchEvent(new DataEvent(PLAYING, false, false, soundChannel.position.toString()));
		}

		public function get volume():Number
		{
			return _volume;
		}

		public function set volume(value:Number):void
		{
			_volume=value;
			soundTransform=soundChannel.soundTransform;
			TweenLite.to(soundTransform, 0.8, {volume: value, onUpdate: pausingHandler});
		}

		/**
		 * 是否静音
		 */
		public function get muted():Boolean
		{
			return _muted;
		}

		public function set muted(value:Boolean):void
		{
			_muted=value;
			if (!soundChannel)
				return;
			volume=value ? 0 : 1;
		}

		private var _volume:Number;

		/**
		 * 暂停音乐
		 */
		public function pause():void
		{
			if (!playing || paused)
				return;
			paused=true;
			if (soundChannel)
			{
				playing=false;
				soundTransform=soundChannel.soundTransform;
//				TweenLite.to(soundTransform, 0.8, {volume: 0, onComplete: pausedHandler, onUpdate: pausingHandler});
				pausedHandler();
			}
			if (internalTimer)
				internalTimer.stop();
		}

		public var paused:Boolean;

		private function stopSoundChannel():void
		{
			if (soundChannel)
			{
				soundChannel.stop();
				soundChannel.removeEventListener(Event.SOUND_COMPLETE, playedHandler);
			}
		}

		/**
		 * 播放音乐
		 */
		public function play():void
		{
			if (playing)
				return;
			paused=false;
			playing=true;
			stopSoundChannel();
			try
			{
				soundChannel=sound.play(currentPosition);
				if (muted)
				{
					soundTransform=soundChannel.soundTransform;
					soundTransform.volume=0;
					soundChannel.soundTransform=soundTransform;
				}
				initIntervalTimer();
				soundChannel.addEventListener(Event.SOUND_COMPLETE, playedHandler);
			}
			catch (error:Error)
			{
				dispatchEvent(new DataEvent('error', false, false, url));
			}
			trace('Sound Player play: ' + url);
		}

		/**
		 * 是否在音频加载完成后自动播放
		 */
		public function get autoPlay():Boolean
		{
			return _autoPlay;
		}

		public function set autoPlay(value:Boolean):void
		{
			_autoPlay=value;
		}

		/**
		 * 是否自动重复播放
		 */
		public function get repeat():Boolean
		{
			return _repeat;
		}

		public function set repeat(value:Boolean):void
		{
			_repeat=value;
		}

		/**
		 * 重播
		 */
		public function replay():void
		{
			playing=false;
			currentPosition=0;
			play();
//			playing=true;
//			if (soundChannel)
//			{
//				soundChannel.stop();
//				soundChannel.removeEventListener(Event.SOUND_COMPLETE, playedHandler);
//			}
//			soundChannel=sound.play(currentPosition);
//			soundChannel.addEventListener(Event.SOUND_COMPLETE, playedHandler);
//			if (muted)
//			{
//				soundTransform=soundChannel.soundTransform;
//				soundTransform.volume=0;
//				soundChannel.soundTransform=soundTransform;
//			}
//			initIntervalTimer();
		}

		/**
		 * 停止播放
		 */
		public function stop():void
		{
			paused = false;
			if (!playing)
				return;
			try
			{
				if (sound)
					sound.close();
			}
			catch (e:Error)
			{

			}
			if (soundChannel)
				soundChannel.stop();
			playing=false;
			if (internalTimer)
				internalTimer.stop();
		}

		/**
		 * 音频URL地址
		 */
		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			if (value == _url)
			{
				currentPosition=0;
				if (internalTimer)
					internalTimer.reset();
				replay();
				return;
			}
			_url=value;
			stop();
			initSound();
			var ur:URLRequest=new URLRequest(value);
			sound.load(ur);
			currentPosition=0;
		}

		private function errorHandler(event:IOErrorEvent):void
		{
			trace(event.toString());
		}

		private function initSound():void
		{
			sound=new Sound();
			sound.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		}

		private function pausedHandler():void
		{
			currentPosition=soundChannel.position;
			soundChannel.stop();
		}

		//声音减缓消失
		private function pausingHandler():void
		{
			soundChannel.soundTransform=soundTransform;
		}

		private function playedHandler(event:Event):void
		{
			trace('Sound Played', url);
			stopInternalTimer();
			dispatchEvent(new Event(PLAY_COMPLETE));
			if (repeat)
			{
				playing=false;
				currentPosition=0;
				play();
			}
		}

		private function progressHandler(event:ProgressEvent):void
		{
			if (autoPlay && event.bytesLoaded == event.bytesTotal)
				play();
		}
	}
}
