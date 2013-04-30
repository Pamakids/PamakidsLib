package services
{
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	import model.Routes;
	import model.content.ContentVO;

	public class ContentService extends ServiceBase
	{
		public function ContentService()
		{
			super();
		}

		/**
		 * 添加交互内容
		 */
		public function addContent(vo:ContentVO, callback:Function):void
		{
			uri=Routes.ADD_CONTENT;
			method=URLRequestMethod.POST;
			call(callback, vo);
		}

		override protected function getURLVariables(data:Object):URLVariables
		{
			return super.getURLVariables(data);
			var vo:ContentVO=data as ContentVO;
			var u:URLVariables=new URLVariables();
			return u;
		}
	}
}
