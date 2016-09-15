//
//  PanView.m
//  WSW_test
//
//  Created by wsw on 16/4/20.
//  Copyright © 2016年 wsw. All rights reserved.
//

#import "PanView.h"
@interface PanView ()
@property (nonatomic, assign) CGPoint beginPoint;
@end

@implementation PanView

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    self.beginPoint = [[touches anyObject] locationInView:self];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGFloat px = [self updatePostion:touches];
    if (px == 0) return;
    
    CGRect frame = [self frame];
    frame.origin.x += px;
    [self setFrame:frame];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGFloat px = [self updatePostion:touches];
    if (px == 0) return;
    
    if (px >= 1)
    {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = [self frame];
            frame.origin.x = 0;
            [self setFrame:frame];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = [self frame];
            frame.origin.x = -self.bounds.size.width/2;
            [self setFrame:frame];
        }];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"-----touchesCancelled-----");
}

- (CGFloat)updatePostion:(NSSet *)touches
{
    CGPoint endPoint = [[touches anyObject] locationInView:self];
    CGFloat px = endPoint.x - self.beginPoint.x;
    
    // 最右边时，向左不能滑动
    if (self.frame.origin.x == -self.bounds.size.width/2 && px < 0)
    {
        return 0;
    }
    // 最左边时，向右不能滑动
    if (self.frame.origin.x == 0 && px > 0)
    {
        return 0;
    }
    return px;
}

@end
