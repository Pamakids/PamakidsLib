package views.book
{
	import com.pamakids.components.controls.Tag;

	import model.content.SubtitleVO;

	public class Subtitle extends Tag
	{
		public function Subtitle(text:String="", width:Number=0, height:Number=0)
		{
			super(text, width, height);
		}

		private var _vo:SubtitleVO;

		public function get vo():SubtitleVO
		{
			return _vo;
		}

		public var useInPreview:Boolean;

		public function set vo(value:SubtitleVO):void
		{
			if (value == _vo && !useInPreview)
				return;
			_vo=value;
			if (value)
			{
				clearBackground();
				clearFrontMask();
				paddingLeft=value.paddingLeft;
				paddingBottom=value.paddingBottom;
				paddingRight=value.paddingRight;
				paddingTop=value.paddingTop;
				frontLeft=value.frontLeft;
				frontRight=value.frontRight;
				frontTop=value.frontTop;
				color=value.color;
				fontSize=value.fontSize;
				text=value.text;
				maxWidth=value.maxWidth;
			}
		}

	}
}
