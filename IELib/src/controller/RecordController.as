package controller
{
	import com.pamakids.utils.Singleton;

	import flash.events.SampleDataEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.Microphone;
	import flash.media.Sound;
	import flash.media.SoundCodec;
	import flash.utils.ByteArray;

	public class RecordController extends Singleton
	{
		private var microphone:Microphone;
		private var bytes:ByteArray;
		private var saveFileName:String;
		private var sound:Sound;

		public static function get instance():RecordController
		{
			return Singleton.getInstance(RecordController);
		}

		public function startRecord(saveFileName:String="temp.mp3"):void
		{
			if (Microphone.isSupported)
			{
				this.saveFileName=saveFileName;
				microphone=Microphone.getMicrophone();
				microphone.rate=16;
				microphone.setUseEchoSuppression(true);
				microphone.codec=SoundCodec.SPEEX;

				bytes=new ByteArray();
				microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, onData);
			}
		}

		protected function onData(event:SampleDataEvent):void
		{
			bytes.writeBytes(event.data);
			trace('on data', event.data);
		}

		public function playRecord(fileName:String="temp.mp3"):void
		{
			var f:File=File.applicationStorageDirectory.resolvePath(fileName);
			var fs:FileStream=new FileStream();
			fs.open(f, FileMode.READ);
			bytes=new ByteArray();
			fs.readBytes(bytes);
//			bytes.uncompress();
			if (bytes.length > 0)
			{
				bytes.position=0;
				sound=new Sound();
				sound.addEventListener(SampleDataEvent.SAMPLE_DATA, playSound);
				sound.play();
			}
			trace('play record:' + fileName, bytes.length);
		}

		public function stopRecord():void
		{
			if (!bytes)
				return;
			microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, onData);
			var f:File=File.applicationStorageDirectory.resolvePath(saveFileName);
			var fs:FileStream=new FileStream();
			fs.open(f, FileMode.WRITE);
//			bytes.compress();
			fs.writeBytes(bytes);
			fs.close();
			bytes=null;
			trace('save record:' + saveFileName, f.nativePath, f.size / 1024 + 'K');
		}

		protected function playSound(event:SampleDataEvent):void
		{
			for (var i:int=0; i < 8192; i++)
			{
				if (bytes.bytesAvailable < 4)
					break;
//				var sample:Number=bytes.readFloat();
//				e.data.writeFloat(sample);
//				e.data.writeFloat(sample);
//				e.data.writeFloat(sample);
//				e.data.writeFloat(sample);
//				if (i % 3)
//				{
//					e.data.writeFloat(sample);
//					e.data.writeFloat(sample);
//				}
				var sampleL:Number=bytes.readFloat();
				var sampleR:Number=bytes.readFloat();
				event.data.writeFloat(sampleL);
				event.data.writeFloat(sampleR);
			}
		}
	}
}

