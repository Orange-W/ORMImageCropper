//
//  ORMImageCropper.h
//  ORMImageCropper
//
//  Created by user on 16/3/31.
//  Copyright © 2016年 mredrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AlertViewController.h"

typedef void (^completeBlock)(UIImage *_Nonnull cropperImage);

@interface ORMImageCropper : NSObject
/* 属性  */

@property (strong, nonatomic, nonnull) AlertViewController *actionSheet;
@property (copy, nonatomic, nullable) NSString *actionSheetTitle;
@property (copy, nonatomic, nullable) NSString *actionSheetMessage;

@property (strong, nonatomic, nonnull)  UIView  *overflowView;//蒙板
@property (strong, nonatomic, nonnull)  UIView  *imageCutView;//剪切基本框

/* 方法  */
/** 快速创建 */
+ (nonnull instancetype)imageCropperInstance;
/** 自定义标题/提示 (全能方法)*/
+ (nonnull instancetype)imageCropperWithTittle:(nullable NSString *)title
                               message:(nullable NSString *)message;

- (void)show;

/**
 *  @author Orange-W, 16-03-31 10:03:26
 *
 *  @brief 快速弹出 actionview 选择框
 *  @param delegate
 *  @param completeBlock 完成后的 block, 将会返回切割后的图片
 */
- (void)setDetegate:(nonnull id) delegate
      compelteBlock:(nullable completeBlock)  completeBlock;


@end