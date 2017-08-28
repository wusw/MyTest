//
//  PanView.h
//  WSW_test
//
//  Created by wsw on 16/4/20.
//  Copyright © 2016年 wsw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PanView;

@protocol PanViewDelegate <NSObject>
- (void)animalViewTouchesEnded:(PanView *)panView;
@end

@interface PanView : UIView

@property (nonatomic, weak) id<PanViewDelegate> delegate;

@end
