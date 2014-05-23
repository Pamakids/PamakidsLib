package components
{
	import com.pamakids.components.base.UIComponent;
	import com.pamakids.components.controls.Image;
	import com.pamakids.utils.URLUtil;

	import flash.display.Bitmap;
	import flash.events.Event;

	public class RecommendMain extends UIComponent
	{
		public var data:Object;

		private var bg:Bitmap;

		public function RecommendMain(width:Number=0, height:Number=0)
		{
			bg=new RecomendAssets.MAINRE();
			addChild(bg);
			super(bg.width, bg.height);
		}

		private var i:Image;

		public function initData():void
		{
			i=new Image(125, 125);
			i.x=width / 2 - i.width / 2;
			i.y=height / 2 - i.height / 2;
			var isHtml:Boolean=URLUtil.isHttp(data.icon);
			if (isHtml)
				i.source=data.icon;
			else
				i.source='assets/recommends/' + data.icon;
			addChildAt(i, 0);
		}
	}
}


