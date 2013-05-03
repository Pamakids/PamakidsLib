package views
{
	import com.pamakids.components.base.Container;

	import views.book.BookPlayer;

	public class Book extends Container
	{
		public function Book(width:Number=0, height:Number=0, useForEditor:Boolean=false)
		{
			super(width, height, false, false);
			player=new BookPlayer(width, height);
		}

		public var player:BookPlayer;

		override protected function init():void
		{
			addChild(player);
		}
	}
}
