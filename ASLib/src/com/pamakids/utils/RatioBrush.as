package com.pamakids.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
		var mShape:Shape = new Shape();
		mShape.graphics.beginFill(0,1)
		mShape.graphics.drawCircle(0,0,25)
		mShape.graphics.endFill()
		painter = new RatioBrush((new AT_img()).bitmapData, mShape)

		bp = new Bitmap()
		bp.bitmapData = painter.target
		addChild(bp)
		bp.x = 100
		bp.y = 200

		stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove)
		function onMove(e:MouseEvent):void
		{
			painter.copyPixelsFromSource(bp.mouseX, bp.mouseY)
			trace(painter.paintedRatio)
		}
	*/
	public class RatioBrush
	{

		public function RatioBrush(source:BitmapData, brush:DisplayObject)
		{
			m_source     =  source
			m_numOpaque  =  source.width * source.height - source.histogram()[3][0]

			this.setBrush(brush)
		}


		/** 目标画像数据 **/
		final public function get target():BitmapData
		{
			return m_target ||= new BitmapData(m_source.width, m_source.height, true, 0x0)
		}

		/** 源画像数据 **/
		final public function get source():BitmapData
		{
			return m_source
		}

		/** 初期非透明像素比率 **/
		final public function get opaqueRatio():Number
		{
			return m_numOpaque / (m_source.width * m_source.height)
		}

		/** 着色比率 **/
		final public function get paintedRatio():Number
		{
			return (m_source.width * m_source.height - target.histogram()[3][0]) / m_numOpaque
		}


		/**
		 * 从源画像复制像素
		 * @param	tx
		 * @param	ty
		 */
		final public function copyPixelsFromSource(tx:int, ty:int):void
		{
			var l:int
			var p:uint

			l = m_brushLength
			while (--l > -1)
			{
				p = m_brushList[l];
				m_target.setPixel32((p & 0xFFFF) + tx + m_offsetX, (p >> 16) + ty + m_offsetY, m_source.getPixel32((p & 0xFFFF) + tx + m_offsetX, (p >> 16) + ty + m_offsetY))
			}
		}

		/**
		 * 设置刷子
		 * @param	brush
		 */
		final public function setBrush(brush:DisplayObject):void
		{
			var x:int, y:int, width:int, height:int
			var BA:BitmapData
			var r:Rectangle
			var matrix:Matrix = new Matrix()

			r          =  brush.getBounds(brush)
			m_offsetX  =  int(r.x)
			m_offsetY  =  int(r.y)
			BA         =  new BitmapData(int(r.width), int(r.height), true, 0x0)

			matrix.translate(-m_offsetX, -m_offsetY)
			BA.draw(brush, matrix)

			m_brushList    =  new Vector.<uint>()
			m_brushLength  =  0
			width          =  BA.width
			height         =  BA.height

			for (y = 0; y < height; y++)
			{
				for (x = 0; x < width; x++)
				{
					if (BA.getPixel32(x, y) > 0)
					{
						m_brushList[m_brushLength++] = (y << 16) | x
					}
				}
			}
			BA.dispose()
		}

		/**
		 * 释放
		 */
		final public function dispose():void
		{
			m_source.dispose()
			m_source = null
			if (m_target)
			{
				m_target.dispose()
				m_target = null
			}
			m_brushList = null
		}


		private var m_source:BitmapData, m_target:BitmapData

		private var m_brushLength:int, m_numOpaque:int // 初期非透明像素数量

		private var m_brushList:Vector.<uint>

		private var m_offsetX:int, m_offsetY:int
	}
}
