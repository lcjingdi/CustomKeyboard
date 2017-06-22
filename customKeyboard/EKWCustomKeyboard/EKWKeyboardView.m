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

@interface EKWKeyboardView()<CAAnimationDelegate>
///自定义的View的类型
@property (nonatomic, assign) KeypboardType type;

@property (nonatomic, strong) UIButton *recordButton;

@property (nonatomic, assign) BOOL isAnimation;

@property (nonatomic, strong) CALayer *recordLayer;

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
        self.backgroundColor = [UIColor whiteColor];
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
//  开始执行动画
- (void)startAnimation{
    self.isAnimation = YES;
    CALayer * spreadLayer;
    spreadLayer = [CALayer layer];
    CGFloat diameter = 200;  //扩散的大小
    spreadLayer.bounds = CGRectMake(0,0, diameter, diameter);
    spreadLayer.cornerRadius = diameter/2; //设置圆角变为圆形
    spreadLayer.position = self.recordButton.center;
    spreadLayer.backgroundColor = [UIColor darkGrayColor].CGColor;
    [self.layer insertSublayer:spreadLayer below:self.recordButton.layer];//把扩散层放到头像按钮下面
    CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 2;
    animationGroup.repeatCount = INFINITY;//重复无限次
    animationGroup.removedOnCompletion = NO;
    animationGroup.timingFunction = defaultCurve;
    //尺寸比例动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.5;//开始的大小
    scaleAnimation.toValue = @1.0;//最后的大小
    scaleAnimation.duration = 2;//动画持续时间
    //透明度动画
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 2;
    opacityAnimation.values = @[@0.4, @0.45,@0];//透明度值的设置
    opacityAnimation.keyTimes = @[@0, @0.2,@1];//关键帧
    opacityAnimation.removedOnCompletion = NO;
    animationGroup.animations = @[scaleAnimation, opacityAnimation];//添加到动画组
    [spreadLayer addAnimation:animationGroup forKey:@"pulse"];
    
    self.recordLayer = spreadLayer;
}

// 移除Layer
- (void)removeLayer:(CALayer*)layer{
    [layer removeFromSuperlayer];
}

- (void)stopAnimation {
    self.isAnimation = NO;
    [self.bufferEngine stop];
    [self removeLayer:self.recordLayer];
}

@end
