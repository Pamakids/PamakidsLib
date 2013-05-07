package views.book
{
	import com.pamakids.components.base.UIComponent;
	import com.pamakids.manager.LoadManager;

	import flash.display.Bitmap;

	public class BookHome extends UIComponent
	{
		private var lm:LoadManager;

		public function BookHome(width:Number=0, height:Number=0)
		{
			super(width, height);
			lm=LoadManager.instance;
			lm.load('assets/home/homeBG.jpg', loadedBGHandler, null, null, null, false, LoadManager.BITMAP);
		}

		private function loadedBGHandler(bt:Bitmap):void
		{
			addChild(bt);
		}
	}
}
