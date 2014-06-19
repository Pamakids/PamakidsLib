package com.pamakids.services
{
	import com.pamakids.models.ResultVO;
	import com.pamakids.utils.CloneUtil;
	import com.pamakids.utils.Singleton;

	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	/**
	 * 上传到七牛云存储的服务
	 * @author mani
	 *
	 */
	public class QNService extends Singleton
	{
		private static function get File():Class
		{
			try
			{
				return getDefinitionByName('flash.filesystem.File') as Class;
			}
			catch (error:Error)
			{
				trace(error);
			}
			return null;
		}

		private var callbackDic:Dictionary;
		private var headers:Array;

		public static var token:String;

		public function QNService()
		{
			callbackDic=new Dictionary();
			headers=[];
			headers.push(new URLRequestHeader('enctype', 'multipart/form-data'));
		}

		public static function get instance():QNService
		{
			return Singleton.getInstance(QNService);
		}

		/**
		 * 获取图片缩略图
		 * @param url 原图地址
		 * @param width 缩略图宽
		 * @param height 缩略图高
		 * @param options 缩放选项
		 * 0 限定缩略图的长边最多为<width>，短边最多为<height>，进行等比缩放，不裁剪。如果只指定 w 参数则表示限定长边（短边自适应），只指定 h 参数则表示限定短边（长边自适应）。
		 * 1 限定缩略图的宽最少为<Width>，高最少为<Height>，进行等比缩放，居中裁剪。转后的缩略图通常恰好是 <Widht>x<Height> 的大小（有一个边缩放的时候会因为超出矩形框而被裁剪掉多余部分）。如果只指定 w 参数或只指定 h 参数，代表限定为长宽相等的正方图。
		 * 2 限定缩略图的宽最多为<Width>，高最多为<Height>，进行等比缩放，不裁剪。如果只指定 w 参数则表示限定长边（短边自适应），只指定 h 参数则表示限定短边（长边自适应）。它和模式0类似，区别只是限定宽和高，不是限定长边和短边。从应用场景来说，模式0适合移动设备上做缩略图，模式2适合PC上做缩略图。
		 * 3 限定缩略图的宽最少为<Width>，高最少为<Height>，进行等比缩放，不裁剪。你可以理解为模式1是模式3的结果再做居中裁剪得到的。
		 * 4 限定缩略图的长边最少为<LongEdge>，短边最少为<ShortEdge>，进行等比缩放，不裁剪。这个模式很适合在手持设备做图片的全屏查看（把这里的长边短边分别设为手机屏幕的分辨率即可），生成的图片尺寸刚好充满整个屏幕（某一个边可能会超出屏幕）。
		 * 5 限定缩略图的长边最少为<LongEdge>，短边最少为<ShortEdge>，进行等比缩放，居中裁剪。同上模式4，但超出限定的矩形部分会被裁剪。
		 * @return
		 *
		 */
		public static function getThumbnail(url:String, width:Number, height:Number, options:int=1):String
		{
			return url + '?imageView2/' + options + '/w/' + width + '/h/' + height;
		}

		public static function getQNThumbnail(key:String, width:Number, height:Number, options:int=1):String
		{
			return HOST + key + '?imageView2/' + options + '/w/' + width + '/h/' + height;
		}

		public static var HOST:String;

		/**
		 * 上传文件
		 * @param file 文件对象
		 * @param callback 回调函数，参数为ResultVO或上传进度数字
		 * @param data {key:"自定义文件名，默认为文件名", "x:test":"自定义属性和值"}
		 */
		public function upload(file:Object, callback:Function, data:Object=null):void
		{
			if (callbackDic[file])
				clearFile(null, file);
			callbackDic[file]=callback;
			var u:URLRequest=new URLRequest('http://up.qiniu.com');
			u.method=URLRequestMethod.POST;
			u.requestHeaders=headers;
			if (!data)
			{
				data=new URLVariables();
				data.key=file.name;
				data.token=token;
			}
			else
			{
				data=getURLVariables(data);
				data.token=data.token ? data.token : token;
			}

			u.data=data;

			file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			file.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
			file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, completeHandler);
			file.upload(u, 'file');
		}

		private static const BOUNDARY:String = "boundary";

//		public static function createMultiPartRequest(bytes:ByteArray, fileProp:String="file1", fileName:String="file1.png", params:Object=null):ByteArray
//		{
//			var header1:String = "\r\n--" + BOUNDARY + "\r\n" + 
//				"Content-Disposition: form-data; name=\""+fileProp+"\"; filename=\""+fileName+"\"\r\n" + 
//				"Content-Type: multipart/form-data\r\n" + "\r\n";
//			var headerBytes1:ByteArray = new ByteArray();
//			headerBytes1.writeMultiByte(header1, "ascii");
//			var postData:ByteArray = new ByteArray();
//			postData.writeBytes(headerBytes1, 0, headerBytes1.length);
//
//			if(bytes)
//				postData.writeBytes(bytes, 0, bytes.length);
//
//			if (!params)
//				params = {};
//			if (!params.Upload)
//				params.Upload = "Submit Query";
//			for (var prop:String in params) {
//				var header:String = "--" + BOUNDARY + "\r\n" + "Content-Disposition: form-data; name=\""+prop+"\"\r\n" + "\r\n" + params[prop]+"\r\n" + "--" + BOUNDARY + "--";
//				var headerBytes:ByteArray = new ByteArray();
//				headerBytes.writeMultiByte(header, "ascii");
//				postData.writeBytes(headerBytes, 0, headerBytes.length);
//			}
//
//			return postData;
//		}

//		public static function httpS(ba:ByteArray,key:String,token:String,filename:String):void
//		{
//			var client:HttpClient = new HttpClient();
//
//			var uri:URI = new URI('http://up.qiniu.com');
//			var contentType:String = "application/octet-stream";
//
////			 Create test data
//			var multipart:Multipart = new Multipart([ 
//				new Part("key", key), 
//				new Part("Content-Type", contentType),
//				new Part("file", ba, contentType, [ { name:"filename", value:filename } ]),
//				new Part("submit", "Upload")
//				]);
//
//
//			client.listener.onComplete = function(event:HttpResponseEvent):void {
//				trace(event);
//			};
//
//			client.postMultipart(uri, multipart);
//		}

		public function uploadBA(ba:ByteArray,data:Object,cb:Function):void
		{
			var ml:MultipartURLLoader=new MultipartURLLoader();
			callbackDic[ml]=cb;

			ml.dataFormat=URLLoaderDataFormat.BINARY;
			ml.addFile(ba, data.filename, 'file');
			ml.addVariable('token', data.token);
			ml.addVariable('key',data.key);

			ml.addEventListener(BAUploadedEvent.EVENT_ID, onBAComplete);
			ml.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			ml.addEventListener(IOErrorEvent.IO_ERROR, onError);
			ml.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);

			ml.load('http://up.qiniu.com');
		}

		protected function getURLVariables(data:Object):URLVariables
		{
			var uv:URLVariables;
			if (data)
			{
				uv=new URLVariables();
				CloneUtil.copyValue(data, uv, true);
			}
			else
			{
				uv=new URLVariables();
			}
			return uv;
		}

		protected function completeHandler(event:DataEvent):void
		{
			callbackDic[event.target](new ResultVO(true, JSON.parse(event.data)));
			clearFile(event);
		}

		protected function onBAComplete(e:BAUploadedEvent):void
		{
			var ld:MultipartURLLoader=e.target as MultipartURLLoader;
			var cb:Function=callbackDic[ld];

			var vo:ResultVO=new ResultVO(true, JSON.parse(e.data as String))
			cb(vo);

			clearFile(e);
		}

		private function clearFile(event:Event, f:Object=null):void
		{
			if(event.target is MultipartURLLoader)
			{
				var ml:MultipartURLLoader=event.target as MultipartURLLoader;
				ml.addEventListener(Event.COMPLETE, onBAComplete);
				ml.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				ml.addEventListener(IOErrorEvent.IO_ERROR, onError);
				ml.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
				ml.dispose();
				delete callbackDic[event.target];
				return;
			}
			var file:Object=event ? event.target as File : f;
			file.cancel();
			file.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			file.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			file.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
			file.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, completeHandler);
			delete callbackDic[file];
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
			if(callbackDic[event.target])
				callbackDic[event.target](new ResultVO(false, '上传失败，请检查网络是否连接',event.toString()));
			clearFile(event);
		}

		protected function errorHandler(event:IOErrorEvent):void
		{
			onError(event);
		}

		protected function progressHandler(event:ProgressEvent):void
		{
			var percent:Number=Math.floor(event.bytesLoaded * 100 / event.bytesTotal);
			callbackDic[event.target](percent);
		}
	}
}

