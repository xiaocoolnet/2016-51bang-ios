//
//  CustomTableViewCell.m
//  QQ自动回复
//
//  Created by 冷求慧 on 15/12/7.
//  Copyright © 2015年 gdd. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "modelFrame.h"
#import "messModel.h"
#define timeFont [UIFont systemFontOfSize:11.0] //时间的字体大小
#define contentFont [UIFont systemFontOfSize:13.0]//聊天消息字体的大小
@interface CustomTableViewCell(){
    UILabel *labelTime;
    UIImageView *imageView;
    UIButton *btnContent;
}
@end
@implementation CustomTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}
//创建各个控件
-(void)createView{
    labelTime=[[UILabel alloc]init]; //添加显示时间的Label
    labelTime.font=timeFont;
    labelTime.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:labelTime];
    
    imageView=[[UIImageView alloc]init]; //添加显示头像的ImageView
    [self.contentView addSubview:imageView];
    
    btnContent=[[UIButton alloc]init]; //添加显示文字的按钮
    btnContent.titleLabel.font=contentFont;
    btnContent.titleLabel.numberOfLines=0;
    btnContent.titleEdgeInsets=UIEdgeInsetsMake(20, 20, 20, 20);//设置按钮文字的的上 左 下 右的边距
    [self.contentView addSubview:btnContent];
    btnContent.enabled=NO;
//    [btnContent setBackgroundColor:[UIColor whiteColor]]; //去除背景颜色即可
}
-(void)setFrameModel:(modelFrame *)frameModel{
    labelTime.frame=frameModel.timeFrame;//设置坐标
    imageView.frame=frameModel.headImageFrame;
    btnContent.frame=frameModel.btnFrame;
    
    if (frameModel.myself) {
        [btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UIImage *bgImage=[UIImage imageNamed:@"chat_send_nor"]; //设置背景图片的
        [btnContent setBackgroundImage:[bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(28, 32, 28, 32) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal]; //拉伸图片的方法(固定图片的位置,其他部分被拉伸)
    }
    else{
        [btnContent setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        UIImage *bgImage=[UIImage imageNamed:@"chat_recive_press_pic"]; //设置背景图片
        [btnContent setBackgroundImage:[bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(28, 32, 28, 32) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    }
    labelTime.text=[NSString stringWithFormat:@"发送:%@",frameModel.dataModel.time];
    imageView.image=[UIImage imageNamed:frameModel.dataModel.imageName];
    [btnContent setTitle:frameModel.dataModel.desc forState:UIControlStateNormal];//设置内容
    
    
}
@end
