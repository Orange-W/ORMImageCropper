//
//  ImageRequestModel.m
//  ORMImageCropper
//
//  Created by user on 16/4/3.
//  Copyright © 2016年 mredrock. All rights reserved.
//

#define kImageRequestUrl @"http://pic.sogou.com/pics"
#define kImageNumberForPage 48

#import "ORMImageRequestModel.h"

@interface ORMImageRequestModel()
@property (strong, nonatomic) ORMImageDataModel *imageDataModel;
@end

@implementation ORMImageRequestModel

+ (NSString *)urlWithQuery:(NSString *)query page:(NSInteger) page
{
    return [NSString stringWithFormat:@"query=%@&start=%ld&reqType=ajax&reqFrom=result",[query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],(long)page*kImageNumberForPage];
}


- (void) requestWithQuery:(NSString *)query
                     page:(NSInteger) page
           handleComplete:(void (^)(ORMImageDataModel *imageModel)) completeBlock{
    NSString *param = [ORMImageRequestModel urlWithQuery:query page:page];
    NSString *param2 =  [NSString stringWithFormat:@"%@?%@",kImageRequestUrl,param];
    NSURL *url = [NSURL URLWithString:param2];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
//    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:60];
    
//    [request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    /***/
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {
                                      if (error) {
                                          return ;
                                      }
                                      //声明一个gbk编码类型
                                      NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                                      
                                      NSString *string = [[NSString alloc]
                                                          initWithData:data
                                                          encoding:gbkEncoding];
                                      
                                      string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
                                     
                                      self.imageDataModel =  [[ORMImageDataModel alloc] initWithDictory:dic];
                                      completeBlock(self.imageDataModel);
//                                      NSLog(@"%@--%@:%@",@"",dic[@"items"],error);
                                      
                                  }];
    [task resume];
}



@end
