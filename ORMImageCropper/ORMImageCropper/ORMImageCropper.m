//
//  ORMImageCropper.m
//  ORMImageCropper
//
//  Created by user on 16/3/31.
//  Copyright © 2016年 mredrock. All rights reserved.
//

#import "ORMImageCropper.h"
#import "ORMOverflowViewController.h"


@interface ORMImageCropper()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/** 完成切图后调用的代理 */
@property (weak, nullable, nonatomic) id delegate;
@property (copy, nullable, nonatomic)completeBlock completeBlock;
@property (strong, nullable, nonatomic)UIImage *editImage;
@end

@implementation ORMImageCropper
#pragma mark - instance
+ (instancetype)imageCropperInstance{
    return [ORMImageCropper imageCropperWithTittle:@"图片来源" message:@"请选择你的图片来源"];
}


+ (instancetype)imageCropperWithTittle:(NSString *)title message:(NSString *)message{
    
    ORMImageCropper *cropper = [[ORMImageCropper alloc] init];
    cropper.actionSheetTitle = title;
    cropper.actionSheetMessage  = message;
    return cropper;
}

#pragma mark - function
- (void)show{
    
    [self.delegate presentViewController:self.actionSheet animated:NO completion:nil];
}

- (void)setDetegate:(id)delegate compelteBlock:(completeBlock)completeBlock{
    self.delegate = delegate;
    self.completeBlock = completeBlock;
}

#pragma mark  alertViewInit
- (AlertViewController *)actionSheet{
    if (_actionSheet == nil) {
        _actionSheet = [AlertViewController alertControllerWithTitle:_actionSheetTitle message:_actionSheetMessage preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancellAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"取消");
        }];
        UIAlertAction *pictureAction = [UIAlertAction
                                        actionWithTitle:@"本地图片"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction *action) {
                                            NSLog(@"本地图片");
                                            [self photoWithSoureType:UIImagePickerControllerSourceTypePhotoLibrary];
                                            
                                        }];
        UIAlertAction * netWorkAction = [UIAlertAction
                                         actionWithTitle:@"互联网图库"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction *action) {
                                             NSLog(@"互联网图库");
                                             ORMOverflowViewController *overflowVC = [[ORMOverflowViewController alloc] initWithNibName:@"ORMOverflowViewController" bundle:nil];
                                             [self.delegate presentViewController:overflowVC animated:YES completion:nil];
                                         }];
        UIAlertAction *captureAction = [UIAlertAction
                                        actionWithTitle:@"摄像头拍照"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction *action) {
                                            NSLog(@"使用摄像头拍照");
                                            [self photoWithSoureType:UIImagePickerControllerSourceTypeCamera];
                                        }];
        
        
        [_actionSheet addAction:cancellAction];
        [_actionSheet addAction:pictureAction];
        [_actionSheet addAction:netWorkAction];
        [_actionSheet addAction:captureAction];
    }
    
    return _actionSheet;
}

- (void)photoWithSoureType:(UIImagePickerControllerSourceType)sourceType{
    if ( sourceType==UIImagePickerControllerSourceTypeCamera && ![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    [self.delegate presentViewController:imagePicker
                                animated:YES
                              completion:^{
                              }];
}

#pragma mark imagePicker代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    self.editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSLog(@"剪切成功%@",info);
    [picker dismissViewControllerAnimated:YES completion:nil];
     self.completeBlock(self.editImage);
    [self.actionSheet popoverPresentationController];
}

@end
