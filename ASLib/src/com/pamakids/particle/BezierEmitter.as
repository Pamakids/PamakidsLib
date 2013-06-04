package com.pamakids.particle
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.pamakids.components.controls.BitmapSprite;
	import com.pamakids.vo.BezierVo;

	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.utils.ByteArray;

	public class BezierEmitter
	{

		public function BezierEmitter(container:DisplayObjectContainer, bitmapData:BitmapData, config:ByteArray)
		{
			mContainer=container
			mBitmapData=bitmapData
			bezierVo=new BezierVo()
			bezierVo.fromByteArray(config)

			easeFunction=bezierVo.easeFunction

			var list:Array=bezierVo.bezierPoints
				if(!list)
					return;
			var i:int, l:int=list.length / 2
			while (i < l)
			{
				nodes.push({x: list[i * 2], y: list[i * 2 + 1]})
				i++
			}
		}



		private var mContainer:DisplayObjectContainer

		private var mBitmapData:BitmapData

		private var bezierVo:BezierVo

		private var nodes:Array=[]

		private var easeFunction:Function

		private var motionObjects:Vector.<BitmapSprite>=new Vector.<BitmapSprite>()

		private var numMotions:int

		private var isRoundStarted:Boolean

		private var roundDelayID:uint


		/** 播放 **/
		public function play():void
		{
			this.startRound()
		}


		/** 停止 **/
		public function stop():void
		{
			if (roundDelayID > 0)
				roundDelayID=0
			TweenMax.killAll();
			removeAllMotionObjects()
		}

		/** 更新 **/
		public function update():void
		{
			if (!isRoundStarted)
				return

			var l:int=bezierVo.maxPerFrame
			var m:int=bezierVo.maxMotions
			var p:Number=bezierVo.probability
			while (--l > -1)
			{
				if ((m <= 0 || numMotions < m) && Math.random() < p / 100)
				{
					this.playTween()
				}
			}
		}


		private function playTween():void
		{
			if(!mBitmapData)
				return;
			var r:Number, d:Number
			var sprite:BitmapSprite

			sprite=BitmapSprite.create(mBitmapData)
			motionObjects[numMotions++]=sprite

			sprite.x=bezierVo.startX
			sprite.y=bezierVo.startY
			sprite.alpha=(bezierVo.alphaMin == bezierVo.alphaMax) ?
				bezierVo.alphaMin :
				bezierVo.alphaMin + Math.random() * (bezierVo.alphaMax - bezierVo.alphaMin)

			r=(bezierVo.scaleMin == bezierVo.scaleMax) ?
				bezierVo.scaleMin :
				bezierVo.scaleMin + Math.random() * (bezierVo.scaleMax - bezierVo.scaleMin)

			sprite.scaleX=sprite.scaleY=r

			r=(bezierVo.durationMin == bezierVo.durationMax) ?
				bezierVo.durationMin :
				bezierVo.durationMin + Math.random() * (bezierVo.durationMax - bezierVo.durationMin)

			d=(bezierVo.delayMin == bezierVo.delayMax) ?
				bezierVo.delayMin :
				bezierVo.delayMin + Math.random() * (bezierVo.delayMax - bezierVo.delayMin)

			TweenMax.to(sprite, r, {delay: d, bezierThrough: nodes, ease: easeFunction,
					onStart: function():void
					{
						mContainer.addChild(sprite)
					},
					onComplete: function():void
					{
						var index:int=motionObjects.indexOf(sprite)
						motionObjects[index]=motionObjects[--numMotions]
						motionObjects.pop()
						sprite.dispose()
					}})
		}

		private function startRound():void
		{
			isRoundStarted=true
			var r:Number

			r=(bezierVo.roundMin == bezierVo.roundMax) ?
				bezierVo.roundMin :
				bezierVo.roundMin + Math.random() * (bezierVo.roundMax - bezierVo.roundMin)

			if (r > 0)
			{
				TweenLite.killDelayedCallsTo(endRound);
				TweenLite.delayedCall(r, endRound);
			}
		}

		private function endRound():void
		{
			isRoundStarted=false
			var r:Number

			r=(bezierVo.nextRoundMin == bezierVo.nextRoundMax) ?
				bezierVo.nextRoundMin :
				bezierVo.nextRoundMin + Math.random() * (bezierVo.nextRoundMax - bezierVo.nextRoundMin)

			TweenLite.killDelayedCallsTo(startRound);
			TweenLite.delayedCall(r, startRound);
		}

		private function removeAllMotionObjects():void
		{
			var l:int=numMotions
			var sprite:BitmapSprite

			while (--l > -1)
			{
				sprite=motionObjects[l]
				sprite.dispose()
			}
			numMotions=motionObjects.length=0
		}



	}
}
