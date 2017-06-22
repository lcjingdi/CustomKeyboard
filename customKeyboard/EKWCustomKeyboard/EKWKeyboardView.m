//
//  EKWKeyboardView.m
//  customKeyboard
//
//  Created by jingdi on 2017/6/21.
//  Copyright © 2017年 ekwing. All rights reserved.
//

#import "EKWKeyboardView.h"

@interface EKWKeyboardView()
///自定义的View的类型
@property (nonatomic, assign) KeypboardType type;
@end

@implementation EKWKeyboardView

+ (instancetype)keyboardViewWithType:(KeypboardType)type {
    return [[EKWKeyboardView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 222) withType:type];
}
- (instancetype)initWithFrame:(CGRect)frame withType:(KeypboardType)type {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.type = type;
        [self initSetup];
    }
    
    return self;
}
#pragma mark - 创建自定义View
- (void)initSetup {
    self.backgroundColor = [UIColor blueColor];
}
@end
