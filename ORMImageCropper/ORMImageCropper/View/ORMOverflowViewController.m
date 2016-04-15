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
@property (strong, atomic) NSBlockOperation *queryOperation;
@property (strong, atomic) NSBlockOperation *requestOperation;
@end

@implementation ORMOverflowViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectView.backgroundColor = [UIColor colorWithRed:255/255.0   green:255/255.0 blue:230/255.0 alpha:1];
    // Do any additional setup after loading the view from its nib.
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
    self.searchBar.delegate = self;
    [self.cancelButton addTarget:self action:@selector(cancelBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    __weak ORMOverflowViewController *weakSelf = self;

    //NSLog(@"%@",requestModel.imageDataodel);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark collectView delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
       cell = [[UICollectionViewCell alloc]init];
    }

    ORMImageModel *imageModel = self.dataModel.imageArray[indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] init];
    CGSize size = [self radioSizeFromImageModel:imageModel];
    imageView.frame = CGRectMake(0, 0, size.width, size.height);
    imageView.backgroundColor = [UIColor grayColor];
    imageView.image = imageModel.image;
    
    UIActivityIndicatorView *active = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    active.center = imageView.center;
    
    if (imageView.image==nil) {
        [active startAnimating];
    }else{
        [active stopAnimating];
    }
    
    [imageView addSubview:active];
    cell.backgroundView = imageView;

    return cell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataModel.imageArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    ORMImageModel *imageModel = self.dataModel.imageArray[indexPath.section*3 + indexPath.row];
    ///定宽等比缩放
    return [self radioSizeFromImageModel:imageModel];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return  10.0;
}

#pragma mark -
#pragma mark searchbar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    if ([self.queryOperation isExecuting] || [self.requestOperation isExecuting]) {
        [self.requestOperation cancel];
        [self.queryOperation cancel];

    }
    //[self.operation cancel];
    self.dataModel =nil;
    NSString *searchString = searchBar.text;
    [self queryStartWithQuery:searchString];
    
}

#pragma mark 返回
- (void)cancelBack{
    NSLog(@"cancel");
    [self  dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark 自定义函数


- (CGSize)radioSizeFromImageModel:(ORMImageModel *)imageModel{
   return CGSizeMake(kImageDivWidth, imageModel.height*kImageDivWidth/imageModel.width);
}

- (void)queryStartWithQuery:(NSString *)searchString{
    ORMImageRequestModel *requestModel = [[ORMImageRequestModel alloc] init];
    __weak ORMOverflowViewController *weakSelf = self;
    self.queryOperation = [NSBlockOperation blockOperationWithBlock:^(){
        
        NSLog(@"执行第1次操作，线程：%@", [NSThread currentThread]);
        [requestModel requestWithQuery:searchString page:0 handleComplete:^(ORMImageDataModel *imageModel) {
            weakSelf.dataModel = imageModel;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [weakSelf.collectView reloadData];
            });
            [self requestOperationStart];
        }];
        
    }];
    
    [self.queryOperation start];
}

- (void)requestOperationStart{
    self.requestOperation = [NSBlockOperation blockOperationWithBlock:^{
        
    }];
    __weak ORMOverflowViewController * weakSelf = self;
    [self.dataModel.imageArray enumerateObjectsUsingBlock:^(ORMImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.image == nil) {
            [weakSelf.requestOperation addExecutionBlock:^() {
                NSLock *lock = [[NSLock alloc] init];
                UIImage *image =[ORMRequestImageModel requestImageWithUrl:obj.pic_url];
                [lock lock];
                //NSLog(@"%@",image);
                obj.image = image;
                [lock unlock];
                NSInteger section = idx/3;
                NSInteger row = idx%3;
                //NSLog(@"新的操作，线程：%@", [NSThread currentThread]);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSLog(@"%ld-%@\ncell：<section:%ld,row:%ld>\n------",idx,obj.pic_url,section,row);
                    //NSLog(@"url:%@",obj.pic_url);
                    [weakSelf.collectView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]]];
                });
            }];
        }
    }];
    [self.requestOperation start];
}

@end
