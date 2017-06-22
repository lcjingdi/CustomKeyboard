//
//  EKWTextField.m
//  customKeyboard
//
//  Created by jingdi on 2017/6/21.
//  Copyright © 2017年 ekwing. All rights reserved.
//

#import "EKWTextField.h"

@implementation EKWTextField

- (instancetype)initWithKeyboardType:(KeypboardType)type {
    self = [super init];
    if (self) {
        
        self.KBType = type;
    }
    return self;
}

- (BOOL)becomeFirstResponder {
    BOOL flag = [super becomeFirstResponder];
    
    return flag;
}

- (BOOL)resignFirstResponder {
    BOOL ret = [super resignFirstResponder];
    
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(textFieldDidResignFirstResponder:)]) {
        [self.textFieldDelegate textFieldDidResignFirstResponder:self];
    }
    
    return ret;
}

- (void)deleteBackward {
    [super deleteBackward];
    
    if (self.textFieldDelegate && [self.textFieldDelegate respondsToSelector:@selector(textFieldDidDeleteString:)]) {
        [self.textFieldDelegate textFieldDidDeleteString:self];
    }
}

@end
