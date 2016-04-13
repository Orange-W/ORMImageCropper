#import <UIKit/UIKit.h>

@interface ORMImageModel : NSObject
@property (assign, nonatomic) NSInteger cacheIndex;
@property (assign, nonatomic) float ratio;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *size;
@property (copy, nonatomic) NSString *pic_url;
@property (assign, nonatomic) NSInteger width;
@property (assign, nonatomic) NSInteger height;
@property (strong, nonatomic) UIImage *image;
@end
