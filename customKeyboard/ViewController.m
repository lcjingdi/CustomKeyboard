//
//  ViewController.m
//  customKeyboard
//
//  Created by jingdi on 2017/6/21.
//  Copyright © 2017年 ekwing. All rights reserved.
//

#import "ViewController.h"
#import "EKWCustomInputView.h"

@interface ViewController ()<EKWCustomInputViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) EKWCustomInputView *inputView;
@end

@implementation ViewController

- (void)customInputViewDidChangeText:(EKWCustomInputView *)inputView {
    self.textView.text = inputView.text;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.textView resignFirstResponder];
    EKWCustomInputView *inputView = [EKWCustomInputView sharedCustomInputViewTypeNormal];
    inputView.InputViewDelegate = self;
    self.inputView = inputView;
    [self.inputView show];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

@end
