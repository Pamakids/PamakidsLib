package views.book
{
	import com.pamakids.components.base.Container;
	import com.pamakids.components.controls.Image;

	import flash.events.Event;

	import controller.PC;

	import model.content.ConversationVO;

	[Event(name="complete", type="flash.events.Event")]
	public class Avatar extends Container
	{
		public function Avatar(vo:ConversationVO)
		{
			this.vo=vo;
			super(0, 0, false, false);
			pc=PC.i;
		}

		private var _vo:ConversationVO;

		private var avatarImage:Image;
		private var pc:PC;

		public function get vo():ConversationVO
		{
			return _vo;
		}

		public function set vo(value:ConversationVO):void
		{
			_vo=value;
			if (avatarImage)
				avatarImage.source=pc.getUrl(value.avatar);
			scaleX=scaleY=value.avatarScale;
		}

		public function updatePosition(settingStartPosition:Boolean):void
		{
			if (!settingStartPosition)
			{
				vo.avatarX=x;
				vo.avatarY=y;
			}
			else
			{
				vo.avatarStartX=x;
				vo.avatarStartY=y;
			}
		}

		override protected function init():void
		{
			avatarImage=new Image();
			if (pc.useByCreator)
				avatarImage.forceAutoFill=true;
			avatarImage.source=pc.getUrl(vo.avatar);
			avatarImage.addEventListener(Event.COMPLETE, completeHandler);
			addChild(avatarImage);
		}

		protected function completeHandler(event:Event):void
		{
			setSize(avatarImage.width, avatarImage.height);
		}
	}
}
