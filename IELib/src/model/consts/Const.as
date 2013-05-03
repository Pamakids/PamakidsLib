package model.consts
{
	import mx.collections.ArrayCollection;

	public class Const
	{
		public static const MOVIE_C:String="1";
		public static const BOOK_C:String="2";
		public static const MOIVE_M:String="3";
		public static const BOOK_M:String="4";
		public static const ALL_C:String="5";
		public static const ALL_M:String="6";

		public static const MOVIE_TYPE:String="1";
		public static const BOOK_TYPE:String="2";

		public static const FILE_EXTENSION:String=".pama";
		public static const BOOK_DATA:String="book.data";
		public static const PAGE_EXTENSION:String=".page";
		public static const ASSET_EXTENSION:String=".asset";
		public static const GAME_EXTENSION:String=".game";
		public static const ALERT_EXTENSION:String=".alert";

		public static const VIDEO_DATA:String="video.data";
		public static const COVER_IMAGE:String="cover.jpg";
		public static const BACKGOURND_MUSIC:String="background.mp3";
		public static const GLOBAL_ASSETS:String="global/assets.data";
		public static const GLOBAL_DIR:String="global";
		/**
		 * 提示，用以游戏之类的开始或结束
		 */
		public static const ALERT_DIR:String="alerts";

		public static const SUBTITLE:String="SUBTITLE";
		public static const CONVERSATION:String="CONVERSATION";
		public static const ASSET_SUBTITLE_BG:String="ASSET_SUBTITLE_BG";
		public static const ASSET_AVATAR:String="ASSET_AVATAR";
		public static const ASSET_THEME:String="ASSET_THEME";
		public static const ASSET_SUBTITLE_FRONT_MASK:String="ASSET_SUBTITLE_FRONT_MASK";
		public static const ASSET_GAME:String="ASSET_GAME";

		public static const VOICE:String="VOICE";
		public static const ASSETS:String="ASSETS";
		public static const GAME:String="GAME";
		public static const CALL:String="CALL";
		public static const TEXT:String="TEXT";

		public static const THUMB_WIDTH:int=137;
		public static const THUMB_HEIGHT:int=85;

		/**
		 * 找茬
		 */
		public static const FIND_WRONG:String="FIND_WRONG";
		public static const SUCCESS:String="SUCCESS";
		public static const FAILURE:String="FAILURE";
		public static const WRONG:String="WRONG";
		public static const RIGHT:String="RIGHT";

		public static const HOT_AREA_ASSET_AUTO_SHOWUP:String="HOT_AREA_ASSET_AUTO_SHOWUP";
		public static const HOT_AREA_ASSET_CLICK_SHOWUP:String="HOT_AREA_ASSET_CLICK_SHOWUP";

		public static const HOT_AREA_ASSET_SHOW_METHODS:Array=[
			{label: '自动出现', type: HOT_AREA_ASSET_AUTO_SHOWUP},
			{label: '点击出现', type: HOT_AREA_ASSET_CLICK_SHOWUP}
			];

		public static const ALERT_TYPES:ArrayCollection=new ArrayCollection([
			{label: '成功', type: SUCCESS},
			{label: '失败', type: FAILURE},
			{label: '出错', type: WRONG},
			{label: '正确', type: RIGHT}
			]);

		public static const HOT_AREA_TYPES:ArrayCollection=new ArrayCollection([
			{label: '找茬游戏', type: FIND_WRONG, tip: '找出视图中不合理的部分'},
			{label: "播放声音", type: VOICE, tip: '点击热区发出声音，可添加素材'},
			{label: "调用素材", type: ASSETS, tip: "可显示也可做简单交互"},
			{label: "调用游戏", type: GAME, tip: "自动运行游戏"}
			]);

		public static const EVENT_TYPES:ArrayCollection=new ArrayCollection([
			{label: "字幕", value: SUBTITLE},
			{label: "对话", value: CONVERSATION},
			{label: "游戏", value: GAME}
			]);

		public static const CONTENT_TYPES:Array=[{label: '影片互动内容', value: MOVIE_TYPE}, {label: '书籍互动内容', value: BOOK_TYPE}];
		public static const PERMISSIONS:Array=[{label: '创建影片互动内容', value: MOVIE_C}, {label: '管理影片互动内容', value: MOIVE_M}, {label: '创建书籍互动内容',
				value: BOOK_C}, {label: '管理书籍互动内容', value: BOOK_M}, {label: '创建所有内容', value: ALL_C},
			{label: "管理所有内容", value: ALL_M}];

		public static const ASSET_TYPES:Array=[
			{label: '对话角色', value: ASSET_AVATAR},
			{label: '字幕背景', value: ASSET_SUBTITLE_BG},
			{label: '字幕前景', value: ASSET_SUBTITLE_FRONT_MASK},
			{label: '游戏', value: ASSET_GAME}
			];
	}
}
