package com.pamakids.utils
{
	import com.pamakids.manager.LoadManager;

	import flash.events.DataEvent;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class QiNiuService extends EventDispatcher
	{
		public function QiNiuService()
		{
		}

		/**
		 *
		 * @param file 上传文件
		 * @param savename 上传文件名(建议与本地文件名一致)
		 * @param completeHandler
		 */
		public static function upload(file:File,savename:String,completeHandler:Function):void
		{
			if(!file.exists)
				return;
			var u:URLRequest=new URLRequest(QINIU_URL); 
			u.method=URLRequestMethod.POST;
			u.requestHeaders=[new URLRequestHeader('enctype', 'multipart/form-data')];
			var ur:URLVariables=new URLVariables();

			ur.key=savename;
			ur.token=token;
			ur['x:param'] = 'Your custom param and value';

			u.data=ur;

			file.upload(u, 'file');  //File or FileReference is both OK, but UploadDataFieldName must be 'file'
//			file.addEventListener(ProgressEvent.PROGRESS,onProgress);
			file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, completeHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR,function(e:Error):void{});
		}

		public static const QINIU_URL:String='http://up.qiniu.com';
		public static var token:String="-S31BNj77Ilqwk5IN85PIBoGg8qlbkqwULiraG0x:NdeCF0RrZDVBxBYvOlTRWzdLH5I=:eyJzY29wZSI6InVzZXJ0ZXN0IiwiZGVhZGxpbmUiOjE3NTI2OTM1MDh9";

		/**
		 *
		 * @param projectname 项目名
		 * @param filename 完整路径
		 * @param completeHandler
		 * @param type 流或bitmap, 对应回调需要注意
		 * @param needSaveLocal 是否本地存储
		 * @param params
		 * @param ioHandle
		 */
		public static function download(projectname:String,filename:String,completeHandler:Function,type:String="",needSaveLocal:Boolean=false,params:Array=null,ioHandle:Function=null):void
		{
			var url:String=getFullImgUrl(projectname,filename);
			LoadManager.instance.load(url,completeHandler,
				needSaveLocal?filename:null,params,null,false,"binary",ioHandle);
		}

		private static function getFullImgUrl(projectname:String,filename:String):String{
			return "http://"+projectname+".qiniudn.com/"+filename;
		}

	}
}

