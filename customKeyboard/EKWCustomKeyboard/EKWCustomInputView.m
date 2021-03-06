//
//  EKWCustomInputView.m
//  customKeyboard
//
//  Created by jingdi on 2017/6/21.
//  Copyright © 2017年 ekwing. All rights reserved.
//

#import "EKWCustomInputView.h"
#import "CustomKeyboardToolbar.h"
#import "EKWKeyboardView.h"

static EKWCustomInputView *keyboardCustomInputViewTypeNormal = nil;
static EKWCustomInputView* keyboardCustomInputViewTypeRecord = nil;

@interface EKWCustomInputView()<UITextFieldDelegate,CustomKeyboardToolbarDelegate,EKWKeyboardViewDelegate,EKWTextFieldDelegate>
@property (nonatomic, assign) KeypboardType type;
@property (nonatomic, strong) EKWKeyboardView *keyboardView;
@end

@implementation EKWCustomInputView

+ (instancetype)sharedCustomInputViewTypeNormal {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keyboardCustomInputViewTypeNormal = [[EKWCustomInputView alloc] initWithKeyboardType:KeypboardTypeNormal];
    });
    return keyboardCustomInputViewTypeNormal;
}
+ (instancetype)sharedCustomInputViewTypeRecord {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keyboardCustomInputViewTypeRecord = [[EKWCustomInputView alloc] initWithKeyboardType:KeypboardTypeRecord];
    });
    return keyboardCustomInputViewTypeRecord;
}

- (void)show {
    UIViewController *topVC = [self getCurrentVC];
    [topVC.view addSubview:self];
    [self.textField becomeFirstResponder];
    self.textField.text = @"";
    self.text = @"";
    
}
- (void)dismiss {
    [self.textField resignFirstResponder];
}
- (instancetype)initWithKeyboardType:(KeypboardType)keyboardType {
    self = [super init];
    
    if (self) {
        self.textField = [[EKWTextField alloc] init];
        self.textField.KBType = KeypboardTypeNormal;
        self.textField.delegate = self;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        CustomKeyboardToolbar *toolbar = [CustomKeyboardToolbar sharedCustomKeyboardToolbar];
        toolbar.keyboardDelegate = self;
        self.textField.inputAccessoryView = toolbar;
        [self addSubview:self.textField];
    }
    
    return self;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    self.text = [self.text stringByAppendingString:string];
    
    if (self.InputViewDelegate && [self.InputViewDelegate respondsToSelector:@selector(customInputViewDidChangeText:)]) {
        [self.InputViewDelegate customInputViewDidChangeText:self];
    }
    
    return YES;
}
- (void)keyboardToolbar:(CustomKeyboardToolbar *)toolbar btnClickType:(Toolbar_type)btnType {
    
    [self.textField resignFirstResponder];
    [self.keyboardView keyboardViewDismiss];
    if (btnType == Toolbar_Type_Keyboard) {
        self.textField.inputView = nil;
        [self.textField becomeFirstResponder];
    } else if (btnType == Toolbar_Type_Record) {
        self.keyboardView = [EKWKeyboardView keyboardViewWithType:KeypboardTypeRecord];
        self.keyboardView.delegate = self;
        self.textField.inputView = self.keyboardView;
        [self.textField becomeFirstResponder];
    }
}

#pragma mark - EKWKeyboardViewDelegate
- (void)keyboardText:(NSString *)text {
    self.text = [self.text stringByAppendingString:text];
    
    if (self.InputViewDelegate && [self.InputViewDelegate respondsToSelector:@selector(customInputViewDidChangeText:)]) {
        [self.InputViewDelegate customInputViewDidChangeText:self];
    }
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
