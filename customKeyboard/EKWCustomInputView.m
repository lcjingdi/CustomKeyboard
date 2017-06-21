//
//  EKWCustomInputView.m
//  customKeyboard
//
//  Created by jingdi on 2017/6/21.
//  Copyright © 2017年 ekwing. All rights reserved.
//

#import "EKWCustomInputView.h"
#import "CustomKeyboardToolbar.h"

static EKWCustomInputView *keyboardCustomInputViewTypeNormal = nil;
static EKWCustomInputView* keyboardCustomInputViewTypeRecord = nil;

@interface EKWCustomInputView()<UITextFieldDelegate,CustomKeyboardToolbarDelegate>
@property (nonatomic, assign) KeypboardType type;
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
    
    self.text = textField.text;
    if (self.InputViewDelegate && [self.InputViewDelegate respondsToSelector:@selector(customInputViewDidChangeText:)]) {
        [self.InputViewDelegate customInputViewDidChangeText:self];
    }
    
    return YES;
}
- (void)keyboardToolbar:(CustomKeyboardToolbar *)toolbar btnClickType:(Toolbar_type)btnType {

    [self.textField resignFirstResponder];
    if (btnType == Toolbar_Type_Record) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 80)];
            v.backgroundColor = [UIColor yellowColor];
            self.textField.inputView = v;
            [self.textField becomeFirstResponder];
        });
        
    } else if (btnType == Toolbar_Type_Keyboard) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.textField.inputView = nil;
            [self.textField becomeFirstResponder];
        });
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
