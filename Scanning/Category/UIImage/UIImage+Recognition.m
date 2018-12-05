//
//  UIImage+Recognition.m
//  Scanning
//
//  Created by 綦帅鹏 on 2018/11/19.
//  Copyright © 2018年 PowesunHolding. All rights reserved.
//

#import "UIImage+Recognition.h"
#import <sys/sysctl.h>
#import <mach/mach.h>

#if DEBUG
#define DebugQRRLog(...)    NSLog(__VA_ARGS__)
#else
#define DebugQRRLog(...)
#endif
@implementation UIImage (Recognition)

/*
 实现逻辑：
 1.原图识别
 2.宽高同比例放大进行识别（依次放大1~10倍，直至识别成功）
 3.放大的最终面积不能超过一定值，超过时按此值进行最后一次识别
 4.图片超过一定存储大小，不再进行放大操作
 
 注意：
 默认图片放大尺寸不超过屏幕尺寸的200倍
 默认图片存储大小超过100MB不再放大
 */
- (void)QRRecognite:(void (^)(NSString *))completionBlock {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self QRRecogniteMaxRate:10 limitArea:screenSize.width*screenSize.height*200 limitMemory:100 completion:completionBlock];
}
- (void)QRRecogniteMaxRate:(int)rate limitArea:(CGFloat)area limitMemory:(CGFloat)memory completion:(void (^)(NSString *codeStr))completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *QRCodeString = nil;
        DebugQRRLog(@"\nimageSize:%@\n", NSStringFromCGSize(self.size));
        // 创建探测器 CIDetectorTypeQRCode
        CIDetector *detector = [CIDetector detectorOfType: CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
        int count = rate > 0 ? rate : 1;
        for (int index = 0; index < count; index++) {
            @autoreleasepool {
                DebugQRRLog(@"index: %i", index + 1);
                // 设置数组，放置识别完之后的数据
                UIImage *image;
                CGFloat limit = area;
                if (index == 0) {
                    image = self;
                } else {
                    if (limit <= 0 || self.size.width*self.size.height > limit) {
                        break;
                    }
                    if (self.size.width*self.size.height*(index + 1)*(index + 1) > limit) {
                        image = [self imageToScale:sqrt(limit/self.size.width/self.size.height)];
                    } else {
                        image = [self imageToScale:index + 1];
                    }
                }
//                DebugQRRLog(@"imageLength: %fMB", UIImagePNGRepresentation(image).length/1024.0/1024.0);
                DebugQRRLog(@"size:%@", NSStringFromCGSize(image.size));
                if (!image) {
                    DebugQRRLog(@"^^^^^^^^^");
                    break;
                }
                
                NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
                
                // 判断是否有数据（即是否是二维码）
                if (features.count > 0) {
                    // 取第一个元素就是二维码所存放的文本信息
                    CIQRCodeFeature *feature = features[0];
                    QRCodeString = feature.messageString;
                    break;
                } else if (UIImagePNGRepresentation(image).length/1024.0/1024.0 > memory) {
                    break;
                } else if (self.size.width*self.size.height*(index + 1)*(index + 1) > limit) {
                    break;
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(QRCodeString);
            }
        });
    });
}
- (UIImage *)imageToScale:(CGFloat)scale {
    CGSize size = CGSizeMake(ceil(self.size.width*scale), ceil(self.size.height*scale));
    return [self imageToSize:size];
}
- (UIImage *)imageToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
