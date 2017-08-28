//
//  ViewController.m
//  SCREENSHOTS
//
//  Created by 徐庆标 on 2017/8/28.
//  Copyright © 2017年 徐庆标. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor redColor];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"截 屏";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    CGFloat width = 100;
    CGFloat height = 50;
    label.frame = CGRectMake((kScreenWidth - width) / 2, (kScreenHeight - height) / 2, width, height);
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationUserDidTakeScreenshotNotification                                                       object:nil queue:mainQueue usingBlock:^(NSNotification *note){
        [self SCREENSHOTS];
        
    }];
}



/*
 1遍历相册
 2删除最后一张
 */
-(void)SCREENSHOTS
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"为了您的账户安全，请避免使用截屏" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        PHFetchResult *onecollectonResuts = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:[PHFetchOptions new]] ;
        [onecollectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            PHAssetCollection *assetCollection = obj;
            if ([assetCollection.localizedTitle isEqualToString:@"Camera Roll"])  {
                PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[PHFetchOptions new]];
                [assetResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                        
                        if (idx == [assetResult count] - 1) {
                            [PHAssetChangeRequest deleteAssets:@[obj]];
                        }
                    } completionHandler:^(BOOL success, NSError *error) {
                    }];
                }];
            }
        }];
    }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}





















































- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
