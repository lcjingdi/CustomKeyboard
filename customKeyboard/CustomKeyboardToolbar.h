//
//  CustomKeyboardToolbar.h
//  customKeyboard
//
//  Created by jingdi on 2017/6/21.
//  Copyright © 2017年 ekwing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomKeyboardToolbar;

/** 输入类型 */
typedef enum{
    /** 点击了完成按钮 */
    Toolbar_Type_Done = 0,
    /** 录音按钮 */
    Toolbar_Type_Record,
    /** 键盘按钮 */
    Toolbar_Type_Keyboard
}Toolbar_type;


@protocol CustomKeyboardToolbarDelegate <NSObject>

@optional
//可选代理方法
- (void)keyboardToolbar:(CustomKeyboardToolbar *)toolbar btnClickType:(Toolbar_type)btnType;

@end

@interface CustomKeyboardToolbar : UIToolbar

@property (nonatomic, assign) Toolbar_type currentType;

+ (instancetype)sharedCustomKeyboardToolbar;

@property (nonatomic, weak) id<CustomKeyboardToolbarDelegate> keyboardDelegate;

@end
