//
//  ShadowView.m
//  Scanning
//
//  Created by 綦 on 17/4/27.
//  Copyright © 2017年 PowesunHolding. All rights reserved.
//

#import "ShadowView.h"
#import <objc/runtime.h>

@interface ShadowView ()

@property (weak, nonatomic) UIImageView *lineImageView;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ShadowView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)dealloc
{
    DebugLog(@"%@销毁了", NSStringFromClass(self.class));
    if (self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)drawRect:(CGRect)rect {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    CGContextAddRect(contextRef, rect);
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.3);
    CGContextFillPath(contextRef);
    
    CGFloat margin = rect.size.width/6.0;
    CGFloat X = margin;
    CGFloat W = margin*4;
    CGFloat H = W;
    CGFloat Y = (rect.size.height - H)/2;
    CGRect clearRect = CGRectMake(X, Y, W, H);
    _scanningRect = CGRectMake(X/rect.size.width, Y/rect.size.height, W/rect.size.width, H/rect.size.height);
    CGContextClearRect(contextRef, clearRect);
    
    CGContextAddRect(contextRef, clearRect);
    CGContextSetRGBStrokeColor(contextRef, 1, 1, 1, 1);
    CGContextSetLineWidth(contextRef, 0.5);
    CGContextStrokePath(contextRef);
    
    for (int index = 0; index < 2; index++) {
        CGFloat length = W/16;
        CGContextMoveToPoint(contextRef, X, Y + length);
        CGContextAddLineToPoint(contextRef, X, Y);
        CGContextAddLineToPoint(contextRef, X + length, Y);
        CGContextSetRGBStrokeColor(contextRef, 0, 1, 0, 1);
        CGContextSetLineWidth(contextRef, 2);
        CGContextStrokePath(contextRef);
        CGContextMoveToPoint(contextRef, X + W - length, Y);
        CGContextAddLineToPoint(contextRef, X + W, Y);
        CGContextAddLineToPoint(contextRef, X + W, Y + length);
        CGContextStrokePath(contextRef);
        
        CGContextTranslateCTM(contextRef, rect.size.width, rect.size.height);
        CGContextRotateCTM(contextRef, M_PI);
    }
    
    if (self.timer == nil) {
        if (self.lineImageView == nil) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(X, Y, W, 2)];
            imageView.image = [UIImage imageNamed:@"2368070-6b5c413149f463c6"];
            [self addSubview:imageView];
            self.lineImageView = imageView;
        }
        NSObject *tagetObj = [[NSObject alloc] init];
        objc_setAssociatedObject(tagetObj, "weakSealf", self, OBJC_ASSOCIATION_ASSIGN);
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:tagetObj selector:@selector(timerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        class_addMethod(tagetObj.class, @selector(timerAction:), (IMP)timerActionIMP, "V@:@");
        [self timerAction:self.timer];
    }
}
void timerActionIMP(id self, SEL _cmd, NSTimer *timer)
{
    id weakSealf = objc_getAssociatedObject(self, "weakSealf");
    [weakSealf timerAction:timer];
}
- (void)timerAction:(NSTimer *)timer
{
    CGFloat margin = self.frame.size.width/6.0;
    CGFloat X = margin;
    CGFloat W = margin*4;
    CGFloat H = W;
    CGFloat Y = (self.frame.size.height - H)/2;
    self.lineImageView.frame = CGRectMake(X, Y, W, 2);
    [UIView animateWithDuration:3 animations:^{
        self.lineImageView.frame = CGRectMake(X, Y + H - 2, W, 2);
    }];
}

@end
