//
//  CustomKeyboardToolbar.m
//  customKeyboard
//
//  Created by jingdi on 2017/6/21.
//  Copyright © 2017年 ekwing. All rights reserved.
//

#import "CustomKeyboardToolbar.h"

@interface CustomKeyboardToolbar()

@end
@implementation CustomKeyboardToolbar

+ (instancetype)sharedCustomKeyboardToolbar {
    CustomKeyboardToolbar *toolbar = [[[NSBundle mainBundle] loadNibNamed:@"Toolbar" owner:nil options:nil] lastObject];
    toolbar.currentType = Toolbar_Type_Keyboard;
    return toolbar;
}

- (IBAction)doneButtonClick:(UIBarButtonItem *)sender {
    if (self.keyboardDelegate && [self.keyboardDelegate respondsToSelector:@selector(keyboardToolbar:btnClickType:)]) {
        self.currentType = Toolbar_Type_Done;
        [self.keyboardDelegate keyboardToolbar:self btnClickType:Toolbar_Type_Done];
    }
}

- (IBAction)recordButtonClick:(UIBarButtonItem *)sender {
    if (self.keyboardDelegate && [self.keyboardDelegate respondsToSelector:@selector(keyboardToolbar:btnClickType:)] && self.currentType != Toolbar_Type_Record) {
        self.currentType = Toolbar_Type_Record;
        [self.keyboardDelegate keyboardToolbar:self btnClickType:Toolbar_Type_Record];
    }
}

- (IBAction)keyboardButtonClick:(UIBarButtonItem *)sender {
    if (self.keyboardDelegate && [self.keyboardDelegate respondsToSelector:@selector(keyboardToolbar:btnClickType:)] && self.currentType != Toolbar_Type_Keyboard) {
        self.currentType = Toolbar_Type_Keyboard;
        [self.keyboardDelegate keyboardToolbar:self btnClickType:Toolbar_Type_Keyboard];
    }
}
@end
