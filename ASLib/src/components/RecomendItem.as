package components
{
	import com.pamakids.components.base.Skin;
	import com.pamakids.components.controls.Image;
	import com.pamakids.utils.URLUtil;

	import flash.events.MouseEvent;

	public class RecomendItem extends Skin
	{
		public var data:Object;

		public function RecomendItem()
		{
			super('');
		}

		override protected function init():void
		{
			var i:Image=new Image(362, 186);
			var isHtml:Boolean=URLUtil.isHttp(data.icon);
			if (isHtml)
				i.source=data.icon;
			else
				i.source='assets/recommends/' + data.icon;
			addChild(i);

			addEventListener(MouseEvent.CLICK, openAppHandler);
		}

		protected function openAppHandler(event:MouseEvent):void
		{
			dispatchEvent(new RecommendEvent(data.url));
//            navigateToURL(new URLRequest(data.url));
		}
	}
}


