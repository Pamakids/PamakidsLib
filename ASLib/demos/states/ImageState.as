package states
{
	import com.pamakids.components.controls.Image;


	public class ImageState extends State
	{

		public function ImageState()
		{

		}


		private var mImage:Image


		override public function enter():void
		{
			mImage=new Image(0, 0)
			mImage.source='assets/default/draw.png';
			this.group.addChild(mImage)
		}


		override public function exit():void
		{
			this.group.removeChild(mImage)
		}

	}

}
