package model.content
{
	import com.pamakids.util.DateUtil;

	[Bindable]
	public class ContentVO
	{
//		var ContentSchema = new Schema({
//			name:{type:'String', trim:true, required: true, index:{uinque: true}},
//			data:{type:'String', required:true},
//			tags:{type:[], get:getTags, set:setTags},
//			comments:[{
//				body:{type:String, required: true},
//				user:{type:Schema.ObjectId, ref:'User', required:true},
//				createdAt:{type:Date, default:Date.now},
//				score:{type:Number, default:5}
//			}],
//			score:{type:Number},
//			status:{type:Number, required:true, default:0},
//			creator:{type: Schema.ObjectId, ref:'Admin', required:true},
//			created:{type:Date, default:Date.now},
//			updated:{type:Date, default:Date.now},
//			updator:{type:Schema.ObjectId, ref:'Admin'},
//			publisher:{type:Schema.ObjectId, ref:'Admin'},
//			publishTime:{type:Date}
//		});
		public function ContentVO()
		{
			created=DateUtil.getYMD(new Date());
		}

		public var name:String;
		public var cover:String;
		public var data:String;
		public var tags:Array;
		public var type:String;
		public var comments:String;
		public var score:String;
		public var status:String;
		public var creator:String;
		public var created:String;
		public var updated:String;
		public var updator:String;
		public var publisher:String;
		public var publishTime:String;

		public function setTags(str:String):void
		{
			if (str)
			{
				var tagString:String=str.replace('，', ',');
				tags=tagString.split(',');
			}
			else
			{
				tags=null;
			}
		}
	}
}
