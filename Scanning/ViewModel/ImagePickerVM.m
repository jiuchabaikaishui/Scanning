//
//  ImagePickerVM.m
//  Scanning
//
//  Created by 綦帅鹏 on 2018/11/16.
//  Copyright © 2018年 PowesunHolding. All rights reserved.
//

#import "ImagePickerVM.h"

@interface ImagePickerVM ()

@property (weak, nonatomic) id<RACSubscriber> subscriber;

@end

@implementation ImagePickerVM

+ (instancetype)create {
    return [[self alloc] init];
}

- (ImagePickerVM * (^)(ImagePickerVMType))typeSet {
    return ^(ImagePickerVMType type) {
        _type = type;
        
        return self;
    };
}

@end
