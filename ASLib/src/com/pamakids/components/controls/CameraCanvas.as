package com.pamakids.components.controls
{
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.CameraPosition;
	import flash.media.Video;

	public class CameraCanvas extends Video
	{
		public function CameraCanvas(width:int=320, height:int=240)
		{
			super(width, height);
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}

		protected function onStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			initCamera();
		}

		private function initCamera():void
		{
			if (Camera.isSupported)
			{
				trace('Init Camera');
				var camera:Camera=getCamera(CameraPosition.FRONT);
				if (camera)
				{
					camera.setMode(width, height, 30);
					attachCamera(camera);
				}
			}
			else
			{
				trace('Camera is not support');
			}
		}

		private function getCamera(position:String):Camera
		{
			for (var i:uint=0; i < Camera.names.length; ++i)
			{
				var cam:Camera=Camera.getCamera(String(i));
				if (cam.position == position)
					return cam;
			}
			return Camera.getCamera();
		}
	}
}
