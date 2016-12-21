//
//  UIBounceButton.m
//
//  Created by dubaoquan on 15/7/15.
//  Copyright (c) 2015年 fosung_newMac. All rights reserved.
//

#import "UIBounceButton.h"

@implementation UIBounceButton

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.currentFont = self.titleLabel.font;
    self.titleLabel.font = [UIFont systemFontOfSize:12.0];
    self.bounds = CGRectMake(0, 0, self.bounds.size.width*0.9, self.bounds.size.height*0.9);
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    self.titleLabel.font = self.currentFont;
    self.bounds = CGRectMake(0, 0, self.bounds.size.width/0.9, self.bounds.size.height/0.9);
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    self.titleLabel.font = self.currentFont;
    [UIView animateWithDuration:0.9 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bounds = CGRectMake(0, 0, self.bounds.size.width/0.9, self.bounds.size.height/0.9);
    } completion:^(BOOL finished) {
        
    }];
   
}
@end
