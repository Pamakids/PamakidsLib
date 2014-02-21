package components
{
    import com.greensock.TweenLite;
    import com.greensock.easing.Cubic;
    import com.pamakids.components.base.Container;
    import com.pamakids.components.base.UIComponent;
    import com.pamakids.components.containers.Panel;
    import com.pamakids.components.controls.Image;
    import com.pamakids.layouts.TileLayout;
    import com.pamakids.layouts.VLayout;
    import com.pamakids.layouts.base.LayoutBase;
    import com.pamakids.manager.AssetsManager;
    import com.pamakids.manager.LoadManager;
    import com.pamakids.utils.URLUtil;
    
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TouchEvent;
    import flash.geom.Point;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.utils.Dictionary;
    
    public class Recommends extends UIComponent
    {
        /**
         * pad 使用 768,1024
         * _iconLocation 0:左上,1:右上,2:左下,3:右下
         *
         * */
        public function Recommends(width:Number, height:Number,_iconLocation:int=3)
        {
            AssetsManager.instance.addAsset("scrollBar",new RecomendAssets.SCROLLBAR());
            iconLocation=_iconLocation
            y=width + width;
            rotation=-90;
            super(width, height);
            
            title=new RecomendAssets.TITLE();
            addChild(title);
            initContents();
        }
        
        public static const ACTIVE:String="RECOMMEND_ACTIVE";
        public static const DEACTIVE:String="RECOMMEND_DEACTIVE";
        
        private var title:Bitmap;
        
        private var iconLocation:int;
        
        protected function closeHandler(event:MouseEvent):void
        {
            dispatchEvent(new Event(Recommends.DEACTIVE));
            toggle();
        }
        
        private function loadDefaultData():void
        {
            lm.load('assets/recommends/data.json', dataLoadedHandler);
        }
        
        private function dataLoadedHandler(datas:String):void
        {
            recommendsData=JSON.parse(datas);
            
            var r:RecommendMain=new RecommendMain();
            r.addEventListener(MouseEvent.CLICK, onClickedHandler);
            r.data=recommendsData.main;
            
            trace(r.width,r.height)
            
            r.rotation=90;
            addChild(r);
            
            switch(iconLocation)
            {
                case 0:
                {
                    r.x=2*width;
                    r.y=0;
                    break;
                }
                
                case 1:
                {
                    r.x=2*width;
                    r.y=height - r.height;
                    break;
                }
                
                case 2:
                {
                    r.x=width + r.width;
                    r.y=0;
                    break;
                }
                
                case 3:
                {
                    r.x=width + r.width;
                    r.y=height - r.height;
                    break;
                }
                
                default:
                {
                    break;
                }
            }
        }
        
        private var hint:RecommendHint;
        private var maskS:Sprite;
        
        protected function onClickedHandler(event:MouseEvent):void
        {
            dispatchEvent(new Event(Recommends.ACTIVE));
            if (!hint)
            {
                var w:Number=parent.width;
                var h:Number=parent.height;
                maskS=new Sprite();
                maskS.graphics.beginFill(0, 0.5);
                maskS.graphics.drawRect(0, 0, w, h);
                maskS.graphics.endFill()
                parent.addChild(maskS);
                TweenLite.to(maskS, 0.5, {alpha: 1});
                
                hint=new RecommendHint();
                hint.init();
                parent.addChild(hint);
                stage.addEventListener(TouchEvent.TOUCH_BEGIN,onTouchBegin);
                stage.addEventListener(TouchEvent.TOUCH_END,onTouchEnd);
            }
            hint.getRandomGesture();
            if(!panel)
                initExpandedContents();
        }
        
        private var tcDic:Dictionary=new Dictionary();
        
        private var checkArr:Vector.<Boolean>=new Vector.<Boolean>(2);
        private var count:int=0;
        
        protected function onTouchEnd(event:TouchEvent):void
        {
            if(!tcDic[event.touchPointID])
                return;
            var check:Boolean=false;
            switch(hint.getCurrentDir())
            {
                case "UP":
                {
                    if(event.stageY<tcDic[event.touchPointID].y)
                        check=true;
                    break;
                }
                case "DOWN":
                {
                    if(event.stageY>tcDic[event.touchPointID].y)
                        check=true;
                    break;
                }
                case "LEFT":
                {
                    if(event.stageX<tcDic[event.touchPointID].x)
                        check=true;
                    break;
                }
                case "RIGHT":
                {
                    if(event.stageX>tcDic[event.touchPointID].x)
                        check=true;
                    break;
                }
                
                default:
                {
                    break;
                }
            }
            
            delete tcDic[event.touchPointID];
            
            if(count<2){
                clearCheck();
                clearHint();
            }
            
            if(check){
                if(!checkArr[0])
                    checkArr[0]=true;
                else{
                    toggle();
                    clearHint();
                    clearCheck();
                }
                
            }else{
                dispatchEvent(new Event(Recommends.DEACTIVE));
                clearCheck();
                clearHint();
            }
        }
        
        private function  clearCheck():void
        {
            count=0;
            for each (var i:int in tcDic) 
            {
                delete 	tcDic[i];
            }
            
            checkArr[0]=false;
        }
        
        protected function onTouchBegin(event:TouchEvent):void
        {
            count++;
            if(count<=2)
                tcDic[event.touchPointID]=new Point(event.stageX,event.stageY);
        }
        
        private function initExpandedContents():void
        {
            panel=new Panel('', width, height - title.height);
            panel.direction=LayoutBase.HORIZONTAL;
            panel.y=title.height;
            addChild(panel);
            
            var contentHeight:Number=377;
            var items:Array=recommendsData.others;
            if (items)
                contentHeight+=10 + Math.ceil(items.length / 2) * 196;
            
            var c:Container=new Container(width, contentHeight);
            c.layout=new VLayout();
            
            var i:Image=new Image(width, 377);
            i.addEventListener(MouseEvent.CLICK, function():void
            {
                navigateToURL(new URLRequest(recommendsData.main.url));
            });
            
            var url:String=recommendsData.main.image;
            var isHtml:Boolean=URLUtil.isHttp(url);
            if (!isHtml)
                url='assets/recommends/' + url;
            i.source=url;
            c.addChild(i);
            
            var itemsC:Container=new Container(width, contentHeight - 377);
            var tl:TileLayout=new TileLayout(2, 10, 10);
            itemsC.layout=tl;
            for each (var itemData:Object in items)
            {
                var item:RecomendItem=new RecomendItem();
                item.data=itemData;
                itemsC.addChild(item);
            }
            c.addChild(itemsC);
            
            panel.addChild(c);
        }
        
        private function toggle():void
        {
            var toy:Number=y == width ? width * 2 : width;
            TweenLite.to(this, 0.8, {y: toy, ease: Cubic.easeOut});
        }
        
//        private var dy:Number;
//        
//        protected function downHandler(event:MouseEvent):void
//        {
//            dy=event.stageY;
//            stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
//        }
        
//        protected function upHandler(event:MouseEvent):void
//        {
//            if (dy > event.stageY)
//                toggle();
//            clearHint();
//            stage.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
//            stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
//        }
        
        private function clearHint():void
        {
            if (hint)
            {
                TweenLite.to(maskS, 0.5, {alpha: 0, onComplete: removeMask});
                parent.removeChild(hint);
                hint=null;
            }
            stage.removeEventListener(TouchEvent.TOUCH_BEGIN,onTouchBegin);
            stage.removeEventListener(TouchEvent.TOUCH_END,onTouchEnd);
        }
        
        private function removeMask():void
        {
            parent.removeChild(maskS);
        }
        
        private var datas:Array;
        
        private var panel:Panel;
        private var lm:LoadManager;
        private var recommendsData:Object;
        
        protected function initContents():void
        {
            var openC:Container=new Container(80, 80, true);
            openC.x=665;
            openC.y=title.height / 2 - 40;
            openC.addEventListener(MouseEvent.CLICK, closeHandler);
            addChild(openC);
            
            var bg:Bitmap=new RecomendAssets.REBG();
            graphics.beginBitmapFill(bg.bitmapData);
            graphics.drawRect(0, 0, width, height);
            graphics.endFill();
            
            lm=LoadManager.instance;
            lm.loadText('http://pamarecommends.qiniudn.com/data.json', dataLoadedHandler);
            lm.errorHandler=loadDefaultData;
        }
    }
}


