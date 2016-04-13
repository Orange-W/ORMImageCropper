//
//  ORMImageDataModel.h
//  ORMImageCropper
//
//  Created by user on 16/4/4.
//  Copyright © 2016年 mredrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORMImageModel.h"




@interface ORMImageDataModel : NSObject
@property (copy,nonatomic) NSString *query;
@property (assign,nonatomic) NSInteger startIndex;
@property (assign ,nonatomic) NSInteger itemsOnPage;
@property (copy, nonatomic) NSString *uuid;
@property (strong,nonatomic) NSMutableArray<ORMImageModel *> *imageArray;

- (ORMImageDataModel *)initWithDictory:(NSDictionary *)dic;
- (void)printImageArray;

@end
