//
//  MainVM.m
//  Scanning
//
//  Created by 綦帅鹏 on 2018/11/16.
//  Copyright © 2018年 PowesunHolding. All rights reserved.
//

#import "MainVM.h"

@implementation MainVM
@synthesize tableViewVM = _tableViewVM;

- (QSPTableViewVM *)tableViewVM {
    if (_tableViewVM == nil) {
        _tableViewVM = [QSPTableViewVM create:^(QSPTableViewVM *vm) {
            vm.addSectionVMCreate(CommonTableViewSectionVM.class, ^(CommonTableViewSectionVM *sectionVM){
                NSString *title = @"扫一扫";
                sectionVM.addRowVMCreate(MainTableVIewCellVM.class, ^(MainTableVIewCellVM *cellVM){
                    cellVM.nextVMSet([ScanningVM create].rectOfInterestSet(NO).titleSet(title)).dataMCreate(CommonM.class, ^(CommonM *model){
                        model.titleSet(title).detailSet(@"不设置rectOfInterest");
                    });
                });
                sectionVM.addRowVMCreate(MainTableVIewCellVM.class, ^(MainTableVIewCellVM *cellVM){
                    cellVM.nextVMSet([ScanningVM create].rectOfInterestSet(YES).titleSet(title)).dataMCreate(CommonM.class, ^(CommonM *model){
                        model.titleSet(title).detailSet(@"设置rectOfInterest");
                    });
                });
                title = @"识别图片";
                sectionVM.addRowVMCreate(MainTableVIewCellVM.class, ^(MainTableVIewCellVM *cellVM){
                    cellVM.nextVMSet([ImagePickerVM create]).dataMCreate(CommonM.class, ^(CommonM *model){
                        model.titleSet(title).detailSet(@"CIDetector");
                    });
                });
                sectionVM.addRowVMCreate(MainTableVIewCellVM.class, ^(MainTableVIewCellVM *cellVM){
                    cellVM.nextVMSet([ImagePickerVM create].typeSet(ImagePickerVMTypeZBarSDK)).dataMCreate(CommonM.class, ^(CommonM *model){
                        model.titleSet(title).detailSet(@"ZBarSDK");
                    });
                });
                sectionVM.addRowVMCreate(MainTableVIewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                    cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                        for (int index = 0; index < 100000; index++) {
                            UILabel *label = [[UILabel alloc] init];
                        }
                    }).dataMCreate(CommonM.class, ^(CommonM *model){
                        model.titleSet(title).detailSet(@"ZBarSDK");
                    });
                });
                sectionVM.addRowVMCreate(MainTableVIewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                    cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                        for (int index = 0; index < 100000; index++) {
                            @autoreleasepool {
                                UILabel *label = [[UILabel alloc] init];
                            }
                        }
                    }).dataMCreate(CommonM.class, ^(CommonM *model){
                        model.titleSet(title).detailSet(@"ZBarSDK");
                    });
                });
                sectionVM.addRowVMCreate(MainTableVIewCellVM.class, ^(CommonTableViewCellVM *cellVM){
                    cellVM.selectedBlockSet(^(UITableView *tableView, NSIndexPath *indexPath){
                        @autoreleasepool {
                            for (int index = 0; index < 100000; index++) {
                                UILabel *label = [[UILabel alloc] init];
                            }
                        }
                    }).dataMCreate(CommonM.class, ^(CommonM *model){
                        model.titleSet(title).detailSet(@"ZBarSDK");
                    });
                });
            });
        }];
    }
    
    return _tableViewVM;
}

@end
