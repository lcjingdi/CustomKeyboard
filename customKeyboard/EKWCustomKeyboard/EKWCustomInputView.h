//
//  EKWCustomInputView.h
//  customKeyboard
//
//  Created by jingdi on 2017/6/21.
//  Copyright © 2017年 ekwing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKWTextField.h"
@class EKWCustomInputView;

@protocol EKWCustomInputViewDelegate <NSObject>

- (void)customInputViewDidChangeText:(EKWCustomInputView *)inputView;

@end


@interface EKWCustomInputView : UIView

@property (nonatomic, strong) EKWTextField *textField;
@property (nonatomic, copy) NSString *text;

@property (nonatomic, weak) id<EKWCustomInputViewDelegate> InputViewDelegate;

+ (instancetype)sharedCustomInputViewTypeNormal;
+ (instancetype)sharedCustomInputViewTypeRecord;
- (instancetype)initWithKeyboardType:(KeypboardType)keyboardType;
- (void)show;
- (void)dismiss;

@end
