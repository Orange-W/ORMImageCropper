//
//  ORMOverflowViewController.m
//  ORMImageCropper
//
//  Created by user on 16/4/2.
//  Copyright © 2016年 mredrock. All rights reserved.
//
#define kImageDivWidth (([UIScreen mainScreen].bounds.size.width-41)/3)

#import "ORMOverflowViewController.h"
#import "ORMImageRequestModel.h"
#import "ORMRequestImageModel.h"

@interface ORMOverflowViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) ORMImageDataModel *dataModel;
@property (strong, atomic) NSBlockOperation *operation;
@end

@implementation ORMOverflowViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
    self.cooectView.delegate = self;
    self.cooectView.dataSource = self;
    
    [self.cooectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    ORMImageRequestModel *requestModel = [[ORMImageRequestModel alloc] init];
    __weak ORMOverflowViewController *weakSelf = self;
    [weakSelf.cooectView reloadData];
    self.operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"执行第2次操作，线程：%@", [NSThread currentThread]);
    }];
    [self.dataModel.imageArray enumerateObjectsUsingBlock:^(ORMImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.image == nil) {
            [self.operation addExecutionBlock:^() {
                NSLock *lock = [[NSLock alloc] init];
                UIImage *image =[ORMRequestImageModel requestImageWithUrl:obj.pic_url];
                [lock lock];
                obj.image = image;
                [lock unlock];
                NSInteger section = idx/3;
                NSInteger row = idx%3;
                NSLog(@"又执行了1个新的操作，线程：%@", [NSThread currentThread]);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSLog(@"线程%@跟新cell：<section:%ld,row:%ld>", [NSThread currentThread],section,row);
                    [weakSelf.cooectView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]]];
                    
                });
                
                
            }];
            
        }
    }];
    
    [[NSBlockOperation blockOperationWithBlock:^(){
        
        NSLog(@"执行第1次操作，线程：%@", [NSThread currentThread]);
        [requestModel requestWithQuery:@"无语" page:0 handleComplete:^(ORMImageDataModel *imageModel) {
            weakSelf.dataModel = imageModel;
            
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [weakSelf.cooectView reloadData];
                
                
                [self.operation start];
                
            });
            
        }];
        
    }] start];
    
    
    [self.operation start];
    
    //NSLog(@"%@",requestModel.imageDataodel);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
       cell = [[UICollectionViewCell alloc]init];
    }

    ORMImageModel *imageModel = self.dataModel.imageArray[indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setFrame:CGRectMake(0, 0, kImageDivWidth, imageModel.height*kImageDivWidth/imageModel.width)];
    imageView.backgroundColor = [UIColor grayColor];
    
    UIActivityIndicatorView *active = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [active setCenter:imageView.center];
    [active startAnimating];
    [imageView addSubview:active];
    
    
    UIImage *requestImage = [ORMRequestImageModel requestImageWithUrl:imageModel.pic_url];
    
    
    [cell setBackgroundView:imageView];
    cell.backgroundColor = [UIColor redColor];

    return cell;
    

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataModel.imageArray.count;
}
//
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    ORMImageModel *imageModel = self.dataModel.imageArray[indexPath.section*3 + indexPath.row];
    
    return CGSizeMake(kImageDivWidth, imageModel.height*kImageDivWidth/imageModel.width);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return  10.0;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"2333");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self
}




@end
