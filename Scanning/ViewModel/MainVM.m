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
                sectionVM.dataMCreate(CommonM.class, ^(CommonM *model){ model.titleSet(@"原生SDK").detailSet(@"有局限"); });
                sectionVM.addRowVMCreate(MainTableVIewCellVM.class, ^(MainTableVIewCellVM *cellVM){
                    cellVM.nextVMSet([NativeScanningVM create].titleSet(title)).dataMCreate(CommonM.class, ^(CommonM *model){
                        model.titleSet(title).detailSet(@"不进行任何设置");
                    });
                });
                sectionVM.addRowVMCreate(MainTableVIewCellVM.class, ^(MainTableVIewCellVM *cellVM){
                    cellVM.nextVMSet([NativeScanningVM create].rectOfInterestSet(YES).titleSet(title)).dataMCreate(CommonM.class, ^(CommonM *model){
                        model.titleSet(title).detailSet(@"设置扫描区域");
                    });
                });
                sectionVM.addRowVMCreate(MainTableVIewCellVM.class, ^(MainTableVIewCellVM *cellVM){
                    cellVM.nextVMSet([NativeScanningVM create].rectOfInterestSet(YES).cameraAutoSet(YES).titleSet(title)).dataMCreate(CommonM.class, ^(CommonM *model){
                        model.titleSet(title).detailSet(@"设置扫描区域与自动白平衡、自动对焦、自动曝光");
                    });
                });
                sectionVM.addRowVMCreate(MainTableVIewCellVM.class, ^(MainTableVIewCellVM *cellVM){
                    cellVM.nextVMSet([NativeScanningVM create].rectOfInterestSet(YES).cameraPushAndPullSet(YES).titleSet(title)).dataMCreate(CommonM.class, ^(CommonM *model){
                        model.titleSet(title).detailSet(@"设置扫描区域与推拉镜头");
                    });
                });
                sectionVM.addRowVMCreate(MainTableVIewCellVM.class, ^(MainTableVIewCellVM *cellVM){
                    cellVM.nextVMSet([NativeScanningVM create].rectOfInterestSet(YES).cameraAutoSet(YES).cameraPushAndPullSet(YES).titleSet(title)).dataMCreate(CommonM.class, ^(CommonM *model){
                        model.titleSet(title).detailSet(@"设置扫描区域，推拉镜头与自动白平衡、自动对焦、自动曝光");
                    });
                });
                title = @"识别图片";
                sectionVM.addRowVMCreate(MainTableVIewCellVM.class, ^(MainTableVIewCellVM *cellVM){
                    cellVM.nextVMSet([ImagePickerVM create]).dataMCreate(CommonM.class, ^(CommonM *model){
                        model.titleSet(title).detailSet(@"CIDetector");
                    });
                });
            });
            
            vm.addSectionVMCreate(CommonTableViewSectionVM.class, ^(CommonTableViewSectionVM *sectionVM){
                NSString *title = @"扫一扫";
                sectionVM.dataMCreate(CommonM.class, ^(CommonM *model){ model.titleSet(@"ZXingSDK").detailSet(@"看看"); });
                sectionVM.addRowVMCreate(MainTableVIewCellVM.class, ^(MainTableVIewCellVM *cellVM){
                    cellVM.nextVMSet([[ZXScanningVM alloc] init]).dataMCreate(CommonM.class, ^(CommonM *model){
                        model.titleSet(title).detailSet(@"使用ZXCapture");
                    });
                });
                title = @"识别图片";
                sectionVM.addRowVMCreate(MainTableVIewCellVM.class, ^(MainTableVIewCellVM *cellVM){
                    cellVM.nextVMSet([ImagePickerVM create].typeSet(ImagePickerVMTypeZXingSDK)).dataMCreate(CommonM.class, ^(CommonM *model){
                        model.titleSet(title).detailSet(@"xxx");
                    });
                });
            });
            
            vm.addSectionVMCreate(CommonTableViewSectionVM.class, ^(CommonTableViewSectionVM *sectionVM){
                NSString *title = @"扫一扫";
                sectionVM.dataMCreate(CommonM.class, ^(CommonM *model){ model.titleSet(@"ZBarSDK").detailSet(@"有问题"); });
                sectionVM.addRowVMCreate(MainTableVIewCellVM.class, ^(MainTableVIewCellVM *cellVM){
                    cellVM.nextVMSet([[ZBarScanningVM alloc] init]).dataMCreate(CommonM.class, ^(CommonM *model){
                        model.titleSet(title).detailSet(@"ZBarReaderViewController直接打开一个扫描界面进行扫描");
                    });
                });
                title = @"识别图片";
                sectionVM.addRowVMCreate(MainTableVIewCellVM.class, ^(MainTableVIewCellVM *cellVM){
                    cellVM.nextVMSet([ImagePickerVM create].typeSet(ImagePickerVMTypeZBarSDK)).dataMCreate(CommonM.class, ^(CommonM *model){
                        model.titleSet(title).detailSet(@"有问题，勿点");
                    });
                });
            });
        }];
    }
    
    return _tableViewVM;
}

@end
