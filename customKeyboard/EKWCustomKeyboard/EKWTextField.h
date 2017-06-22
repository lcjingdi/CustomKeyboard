//
//  EKWTextField.h
//  customKeyboard
//
//  Created by jingdi on 2017/6/21.
//  Copyright © 2017年 ekwing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKWKeyboardView.h"
@class EKWTextField;

@protocol EKWTextFieldDelegate <NSObject>

- (void)textFieldDidResignFirstResponder:(EKWTextField *)textField;
- (void)textFieldDidDeleteString:(EKWTextField *)textField;

@end

@interface EKWTextField : UITextField

@property (nonatomic, assign) KeypboardType KBType;
@property (nonatomic, weak) id<EKWTextFieldDelegate> textFieldDelegate;

- (instancetype)initWithKeyboardType:(KeypboardType)type;

@end
