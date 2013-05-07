package
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.TransformAroundPointPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.pamakids.manager.AssetsManager;
	import com.pamakids.utils.BitmapDataUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Camera;
	import flash.media.CameraPosition;
	import flash.media.Video;
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
	import states.RollawayState;
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

		private static var mStateList:Array=
		[
			ButtonState, 
			ImageState, 
			PanelState,
			RollawayState
		];



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
				
				
			/*var bitmap:Bitmap = new Bitmap(new BitmapData(600,400,true,0xff333333))
			this.addChild(bitmap)
			stage.addEventListener(MouseEvent.MOUSE_MOVE,function(e:MouseEvent):void
			{
				//var p:point = bitmap.globalToLocal(new Point(stage.mouseX,))
				BitmapDataUtil.erase(bitmap.bitmapData, bitmap.mouseX, bitmap.mouseY,2,5, 0.3)
				
			})*/
				
				/*var video:Video = new Video()
			this.addChild(video)
				
			var camera:Camera
			
			camera = Camera.getCamera(CameraPosition.BACK)
				
			trace(Camera.isSupported)
				
			camera = Camera.getCamera()
			if(camera)
			{
				trace('normal')
				video.attachCamera(camera)
				camera.setMode(320,240,30)
			}*/
			
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
