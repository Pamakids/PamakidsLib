package com.pamakids.services
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.Dictionary;

	/**
	 * 上传服务
	 * @author mani
	 */
	public class UploadService extends ServiceBase
	{
		public static const UPLOAD:String="upload";
		private var callbackDic:Dictionary;
		private var progressDic:Dictionary;

		public function UploadService()
		{
			callbackDic=new Dictionary();
			progressDic=new Dictionary();
			super(UPLOAD, URLRequestMethod.POST);
			headers=[];
			headers.push(new URLRequestHeader('Content-Type', 'multipart/form-data'));
			headers.push(new URLRequestHeader('UploadFile', 'true'));
		}

		public function upload(file:File, compCallback:Function, data:Object=null, progressCallback:Function=null):void
		{
			if (callbackDic[file])
				clearFile(null, file);
			callbackDic[file]=compCallback;
			progressDic[file]=progressCallback;
			var u:URLRequest=getURLRequest(getURLVariables(data));
			file.upload(u, 'upload');
			file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			file.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
			file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, completeHandler);
		}

		protected function completeHandler(event:DataEvent):void
		{
			callbackDic[event.target](event.data);
			clearFile(event);
		}

		private function clearFile(event:Event, f:File=null):void
		{
			var file:File=event ? event.target as File : f;
			file.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			file.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			file.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
			file.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, completeHandler);
			delete callbackDic[file];
			delete progressDic[file];
		}

		protected function onStatus(event:HTTPStatusEvent):void
		{
			var status:int=event.status;
			if (status && status != 200)
				onError(event);
		}

		private function onError(event:Event):void
		{
			trace('ErrorString:', event.toString());
			clearFile(event);
		}

		protected function errorHandler(event:IOErrorEvent):void
		{
			onError(event);
		}

		protected function progressHandler(event:ProgressEvent):void
		{
			var percent:Number=Math.floor(event.bytesLoaded * 100 / event.bytesTotal);
			progressDic[event.target](percent);
		}
	}
}

