//
//  setPlacehoder.m
//  51Bang_ios_2016
//
//  Created by DreamCool on 16/8/4.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

#import "setPlacehoder.h"

@implementation setPlacehoder

+(void)setmyPlaceholder:(UITextField *)field size:(CGFloat)yoursize
{
    NSString *holderText = @"jjfdsaffdsafdsa";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:holderText];
    [placeholder addAttribute: NSFontAttributeName
                       value:[UIFont boldSystemFontOfSize:yoursize]
                       range:NSMakeRange(0, holderText.length)];
    field.attributedPlaceholder = placeholder;
}
@end
