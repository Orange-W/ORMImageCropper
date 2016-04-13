//
//  ImageRequestModel.h
//  ORMImageCropper
//
//  Created by user on 16/4/3.
//  Copyright © 2016年 mredrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORMImageDataModel.h"

@interface ORMImageRequestModel : NSObject

- (void) requestWithQuery:(NSString *)query
                     page:(NSInteger) page
           handleComplete:(void (^)(ORMImageDataModel *imageModel)) completeBlock;


@end
