//
//  UIImage+Recognition.h
//  Scanning
//
//  Created by 綦帅鹏 on 2018/11/19.
//  Copyright © 2018年 PowesunHolding. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (Recognition)

/**
 识别图片二维码

 @param completionBlock 完成后的回调
 */
- (void)QRRecognite:(void (^)(NSString *codeStr))completionBlock;

/**
 识别图片二维码

 @param rate 图片进行缩放的最大倍率
 @param area 限制面积（超过不再放大）
 @param memory 限制存储大小（超过不再放大，单位为MB）
 @param completionBlock 完成后的回调
 */
- (void)QRRecogniteMaxRate:(int)rate limitArea:(CGFloat)area limitMemory:(CGFloat)memory completion:(void (^)(NSString *codeStr))completionBlock;

- (void)rectangleRecognite:(void (^)(NSString *codeStr))completionBlock;

NS_ASSUME_NONNULL_BEGIN

@end

NS_ASSUME_NONNULL_END
