//
//  ORMRequestImageModel.m
//  ORMImageCropper
//
//  Created by user on 16/4/11.
//  Copyright © 2016年 mredrock. All rights reserved.
//
#import "ORMRequestImageModel.h"

@implementation ORMRequestImageModel:NSObject

+ (id)requestImageWithUrl:(NSString *)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

@end
