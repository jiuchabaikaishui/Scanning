//
//  MainTableVIewCellVM.m
//  Scanning
//
//  Created by 綦帅鹏 on 2018/11/16.
//  Copyright © 2018年 PowesunHolding. All rights reserved.
//

#import "MainTableVIewCellVM.h"

@implementation MainTableVIewCellVM

- (MainTableVIewCellVM * (^)(BaseViewControllerVM *))nextVMSet {
    return ^(BaseViewControllerVM *vm) {
        _nextVM = vm;
        
        return self;
    };
}

@end
