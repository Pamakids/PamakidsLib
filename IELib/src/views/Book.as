package views
{
	import com.pamakids.components.base.Container;

	import views.book.BookHome;
	import views.book.BookPlayer;

	public class Book extends Container
	{
		public function Book(width:Number=0, height:Number=0, useForEditor:Boolean=false)
		{
			super(width, height, false, false);
			this.useForEditor=useForEditor;
			if (useForEditor)
				player=new BookPlayer(width, height);
		}

		public var player:BookPlayer;
		private var useForEditor:Boolean;
		private var bookHome:BookHome;

		override protected function init():void
		{
			if (useForEditor)
			{
				addChild(player);
			}
			else
			{
				bookHome=new BookHome(width, height);
				addChild(bookHome);
			}
		}
	}
}
