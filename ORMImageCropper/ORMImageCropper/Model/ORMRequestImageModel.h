//
//  ORMRequestImageModel.h
//  ORMImageCropper
//
//  Created by user on 16/4/11.
//  Copyright © 2016年 mredrock. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ORMRequestImageModel : NSObject
+ (UIImage *)requestImageWithUrl:(NSString *)urlString;
@end
