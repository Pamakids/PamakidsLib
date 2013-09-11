package com.pamakids.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	/**
	 * 更高效的存取图片，不经过图形编码解码
	 * @author mani
	 */
	public class BitmapSerialize
	{
		/**
		 * Bitmap to ByteArray
		 */
		public static function encode(bitmap:Bitmap):ByteArray
		{
			var bytes:ByteArray=new ByteArray();
			bytes.writeUnsignedInt(bitmap.bitmapData.width);
			bytes.writeBytes(bitmap.bitmapData.getPixels(bitmap.bitmapData.rect));
			bytes.compress();
			return bytes;
		}

		/**
		 * ByteArray to Bitmap
		 */
		public static function decode(bytes:ByteArray):Bitmap
		{
			var bitmap:Bitmap=null;
			try
			{
				bytes.uncompress();
				var width:int=bytes.readUnsignedInt();
				var height:int=((bytes.length - 4) / 4) / width;
				var bmd:BitmapData=new BitmapData(width, height, true, 0);
				bmd.setPixels(bmd.rect, bytes);
				bitmap=new Bitmap(bmd);
			}
			catch (e:Error)
			{
				trace('BitmapSerialize error uncompressing bytes');
			}
			return bitmap;
		}
	}
}
