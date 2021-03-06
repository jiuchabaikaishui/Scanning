//
//  BaseVM.h
//  Review
//
//  Created by 綦帅鹏 on 2018/11/13.
//  Copyright © 2018年 QSP. All rights reserved.
//

#import "QSPViewVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewControllerVM : QSPViewVM

@property (copy, nonatomic, copy) NSString *title;

- (BaseViewControllerVM * (^)(NSString *))titleSet;

@end

NS_ASSUME_NONNULL_END
