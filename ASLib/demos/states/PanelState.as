package states
{
	import com.pamakids.components.containers.Panel;
	import com.pamakids.components.controls.Image;
	import com.pamakids.layouts.TileLayout;

	public class PanelState extends State
	{

		private var mPanel:Panel
		private var mImage:Image

		override public function enter():void
		{
			var l:int, i:int


			// Vertical Layout
			mPanel=new Panel('', 700, 800)
			//mPanel.layout=new VLayout()
			//mPanel.layout=new HLayout()
			mPanel.layout=new TileLayout(3, 5, 5)

			this.group.addChild(mPanel)

			i=0
			l=8
			while (i < l)
			{
				mImage=new Image(48, 48)
				mImage.source='assets/default/0' + (++i) + '.png';
				mPanel.addChild(mImage)
			}
		}


		override public function exit():void
		{
			this.group.removeChild(mPanel)
		}

	}

}
