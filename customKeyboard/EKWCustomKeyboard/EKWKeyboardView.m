//
//  EKWKeyboardView.m
//  customKeyboard
//
//  Created by jingdi on 2017/6/21.
//  Copyright © 2017年 ekwing. All rights reserved.
//

#import "EKWKeyboardView.h"
#import <Speech/Speech.h>

#define KEYBOARDHEIGHT 216

@interface EKWKeyboardView()
///自定义的View的类型
@property (nonatomic, assign) KeypboardType type;

@property (nonatomic, strong) UIButton *recordButton;

@property (nonatomic, assign) BOOL isAnimation;

@property(nonatomic,strong)SFSpeechRecognizer *bufferRec;
@property(nonatomic,strong)AVAudioEngine *bufferEngine;
@property(nonatomic,strong)AVAudioInputNode *buffeInputNode;

@property(nonatomic,strong)SFSpeechRecognitionTask *bufferTask;
@property(nonatomic,strong)SFSpeechAudioBufferRecognitionRequest *bufferRequest;

@end

@implementation EKWKeyboardView

+ (instancetype)keyboardViewWithType:(KeypboardType)type {
    return [[EKWKeyboardView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, KEYBOARDHEIGHT) withType:type];
}
- (instancetype)initWithFrame:(CGRect)frame withType:(KeypboardType)type {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.isAnimation = NO;
        self.type = type;
        [self initSetup];
    }
    
    return self;
}
#pragma mark - 创建键盘View
- (void)initSetup {
    if (KeypboardTypeRecord == self.type) {
        [self setRecordKeyboard];
    }
}

- (void)setRecordKeyboard {
    
    self.recordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    self.isAnimation = NO;
    [self.recordButton addTarget:self action:@selector(recordButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.recordButton.center = self.center;
    [self.recordButton setBackgroundImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    [self addSubview:self.recordButton];
    
}

#pragma mark - event
- (void)recordButtonClick {
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        if (status != SFSpeechRecognizerAuthorizationStatusAuthorized) {
            UILabel *label = [[UILabel alloc] init];
            label.text = @"12345324234234";
            [label sizeToFit];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                label.center = self.center;
                [self addSubview:label];
            });
        }
    }];
    
    [self startRecord];
}
- (void)startRecord {
    
    if (self.isAnimation) {
        [self stopAnimation];
    } else {
        [self startAnimation];
        
        self.bufferRec = [[SFSpeechRecognizer alloc] initWithLocale:[NSLocale localeWithLocaleIdentifier:@"en-US"]];
        self.bufferEngine = [[AVAudioEngine alloc] init];
        self.buffeInputNode = [self.bufferEngine inputNode];
        if (_bufferTask != nil) {
            [_bufferTask cancel];
            _bufferTask = nil;
        }
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
        [audioSession setMode:AVAudioSessionModeMeasurement error:nil];
        [audioSession setActive:true error:nil];
        
        // block外的代码也都是准备工作，参数初始设置等
        self.bufferRequest = [[SFSpeechAudioBufferRecognitionRequest alloc]init];
        self.bufferRequest.shouldReportPartialResults = true;
        __weak EKWKeyboardView *weakSelf = self;
        self.bufferTask = [self.bufferRec recognitionTaskWithRequest:self.bufferRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
            
            if (result != nil) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardText:)]) {
                    [self.delegate keyboardText:result.bestTranscription.formattedString];
                }
            }
            if (error != nil) {
                NSLog(@"%@",error.userInfo);
            }
        }];
        
        // 监听一个标识位并拼接流文件
        AVAudioFormat *format =[self.buffeInputNode outputFormatForBus:0];
        [self.buffeInputNode installTapOnBus:0 bufferSize:1024 format:format block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
            [weakSelf.bufferRequest appendAudioPCMBuffer:buffer];
        }];
        
        // 准备并启动引擎
        [self.bufferEngine prepare];
        NSError *error = nil;
        if (![self.bufferEngine startAndReturnError:&error]) {
            NSLog(@"%@",error.userInfo);
        };
    }
}

- (void)startAnimation {
    self.isAnimation = YES;
}
- (void)stopAnimation {
    self.isAnimation = NO;
    [self.bufferEngine stop];
}

@end
