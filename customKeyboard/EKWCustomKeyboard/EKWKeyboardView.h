//
//  EKWKeyboardView.h
//  customKeyboard
//
//  Created by jingdi on 2017/6/21.
//  Copyright © 2017年 ekwing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EKWKeyboardViewDelegate <NSObject>

- (void)keyboardText:(NSString *)text;

@end

typedef NS_ENUM(NSInteger,KeypboardType){
    KeypboardTypeNormal         = 1 << 0,
    KeypboardTypeRecord         = 1 << 1
};

@interface EKWKeyboardView : UIView

@property (nonatomic, weak) id<EKWKeyboardViewDelegate> delegate;

+ (instancetype)keyboardViewWithType:(KeypboardType)type;

- (void)keyboardViewDismiss;

@end

