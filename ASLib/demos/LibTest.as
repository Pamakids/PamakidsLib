package
{
	import com.pamakids.manager.AssetsManager;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	import org.despair2D.Despair;
	import org.despair2D.StatsKai;
	import org.despair2D.control.KeyboardManager;
	import org.despair2D.renderer.IView;
	import org.despair2D.renderer.ViewProxy;
	import org.despair2D.resource.ILoader;
	import org.despair2D.resource.LoaderManager;

	import states.ButtonState;
	import states.ImageState;
	import states.PanelState;
	import states.State;

	public class LibTest extends Sprite
	{

		public function LibTest()
		{
			if (stage)
			{
				init()
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init)
			}

		}

		private static var mStateList:Array=[ButtonState, ImageState, PanelState];



		private function init(e:Event=null):void
		{
			mGroup=new Sprite()
			this.addChild(mGroup)

			mLength=mStateList.length

			Despair.startup(stage)
			KeyboardManager.getInstance().initialize()
			KeyboardManager.getInstance().getState().addPressListener('LEFT', function():void
			{
				if (--mIndex < 0)
				{
					mIndex=mLength - 1
				}
				changeState()
			})
			KeyboardManager.getInstance().getState().addPressListener('RIGHT', function():void
			{
				if (++mIndex >= mLength)
				{
					mIndex=0
				}
				changeState()
			})

			//AssetsManager.instance.loadTheme('assets/defaultTheme.json')
			//am.addLoadedCallback(onThemeLoaded);

			trace('[init] - 初期化...')
			this.changeState()
		}


		private function changeState():void
		{
			if (mState)
			{
				mState.exit()
			}

			mState=new (mStateList[mIndex] as Class);

			trace('[enter] - ' + getQualifiedClassName(mState))
			mState.enter()
		}



		private var mIndex:int

		private var mLength:int

		private var mState:State

		public static var mGroup:Sprite
	}

}
