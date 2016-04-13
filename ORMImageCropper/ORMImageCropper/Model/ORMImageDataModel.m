//
//  ORMImageDataModel.m
//  ORMImageCropper
//
//  Created by user on 16/4/4.
//  Copyright © 2016年 mredrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORMImageDataModel.h"

@implementation ORMImageDataModel

- (ORMImageDataModel *)initWithDictory:(NSDictionary *)dic{
    self.imageArray = [[NSMutableArray alloc] init];
    self.query = dic[@"query"];
    self.uuid = dic[@"uuid"];
    self.startIndex = [dic[@"startIndex"] integerValue];
    self.itemsOnPage = [dic[@"itemsOnPage"] integerValue];
    for (NSDictionary *tmpDic in dic[@"items"]) {
        ORMImageModel *imgModel = [[ORMImageModel alloc] init];
        imgModel.title = tmpDic[@"title"];
        imgModel.size = tmpDic[@"size"];
        imgModel.cacheIndex = [tmpDic[@"cacheIndex"] integerValue];
        imgModel.pic_url = tmpDic[@"pic_url"];
        imgModel.width = [tmpDic[@"width"] integerValue];
        imgModel.height = [tmpDic[@"height"] integerValue];
        imgModel.ratio = 1.0*imgModel.width/imgModel.height;
        [self.imageArray addObject:imgModel];
    }
    return self;
}

- (void)printImageArray{
    for (ORMImageModel *model in self.imageArray) {
        NSLog(@"%ld %@\ntitle:%@\nurl:%@\nW:%ld H:%ld ratio:%f\n------",(long)model.cacheIndex,model.size,model.title,model.pic_url,(long)model.width,model.height,model.ratio);
        
    }
}

@end