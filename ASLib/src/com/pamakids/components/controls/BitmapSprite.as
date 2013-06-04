package com.pamakids.components.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;


	public class BitmapSprite extends Sprite
	{



		public static function create(bitmapRefOrData:*, alignCode:int=5, smoothing:Boolean=true, mouseChildren:Boolean=false):BitmapSprite
		{
			var sprite:BitmapSprite

			sprite=(cachedLength > 0 ? cachedLength-- : 0) ? cachedList.pop() : new BitmapSprite()
			if (bitmapRefOrData is Class)
			{
				sprite.m_bitmap=new (bitmapRefOrData as Class)
			}

			else if (bitmapRefOrData is BitmapData)
			{
				sprite.m_bitmap=new Bitmap((bitmapRefOrData as BitmapData).clone())
			}

			sprite.align(alignCode)
			sprite.smoothing=smoothing
			sprite.addChild(sprite.m_bitmap)
			sprite.mouseChildren=mouseChildren
			return sprite
		}


		public function get smoothing():Boolean
		{
			return m_smoothing
		}

		public function set smoothing(b:Boolean):void
		{
			m_smoothing=m_bitmap.smoothing=b
		}


		public function get bitmapData():BitmapData
		{
			return m_bitmap.bitmapData
		}


		public function set bitmapData(v:BitmapData):void
		{
			m_bitmap.bitmapData.dispose()
			m_bitmap.bitmapData=v
			m_bitmap.smoothing=m_smoothing
			this.align(m_alignCode)
		}


		public function setBitmap(bitmapRef:Class):void
		{
			this.removeChild(m_bitmap)
			m_bitmap.bitmapData.dispose()
			m_bitmap.bitmapData=null
			m_bitmap=new bitmapRef
			m_bitmap.smoothing=m_smoothing
			this.addChild(m_bitmap)
			this.align(m_alignCode)
		}


		public function dispose():void
		{
			if (this.parent)
			{
				this.parent.removeChild(this)
			}
			while (this.numChildren)
			{
				removeChildAt(0)
			}
			m_bitmap.bitmapData.dispose()
			this.alpha=this.scaleX=this.scaleY=1
			this.x=this.y=0
			rotation=0;
			this.visible=true;

			cachedList[cachedLength++]=this
		}


		public function align(alignCode:int):void
		{
			m_alignCode=alignCode
			switch (alignCode)
			{
				case 7:
					m_bitmap.x=m_bitmap.y=0
					break

				case 8:
					m_bitmap.x=-m_bitmap.width / 2
					m_bitmap.y=0
					break

				case 9:
					m_bitmap.x=-m_bitmap.width
					m_bitmap.y=0
					break

				case 4:
					m_bitmap.x=0
					m_bitmap.y=-m_bitmap.height / 2
					break

				case 5:
					m_bitmap.x=-m_bitmap.width / 2
					m_bitmap.y=-m_bitmap.height / 2
					break

				case 6:
					m_bitmap.x=-m_bitmap.width
					m_bitmap.y=-m_bitmap.height / 2
					break

				case 1:
					m_bitmap.x=0
					m_bitmap.y=-m_bitmap.height
					break

				case 2:
					m_bitmap.x=-m_bitmap.width / 2
					m_bitmap.y=-m_bitmap.height
					break

				case 3:
					m_bitmap.x=-m_bitmap.width
					m_bitmap.y=-m_bitmap.height
					break
			}
		}


		internal var m_bitmap:Bitmap

		internal var m_alignCode:int

		internal var m_smoothing:Boolean


		private static var cachedList:Array=[]
		private static var cachedLength:int


		public static function get numCached():int
		{
			return cachedLength
		}

	}

}
