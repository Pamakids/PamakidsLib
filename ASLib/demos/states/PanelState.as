package states 
{
	import com.pamakids.components.controls.Panel;
	import com.pamakids.layouts.VLayout;
	
	public class PanelState extends State 
	{
		
		private var mPanel:Panel
		
		override public function enter() : void
		{
			mPanel = new Panel('', 500, 500)
			mPanel.layout = new VLayout()
			this.group.addChild(mPanel)
		}
		
		
		override public function exit() : void
		{
		}
		
	}

}