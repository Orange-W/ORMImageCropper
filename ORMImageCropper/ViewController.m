//
//  ViewController.m
//  ORMImageCropper
//
//  Created by user on 16/3/31.
//  Copyright © 2016年 mredrock. All rights reserved.
//

#import "ViewController.h"
#import "ORMImageCropper.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)click:(id)sender {
    ORMImageCropper *cropper = [ORMImageCropper imageCropperInstance];
    [cropper setDetegate:self compelteBlock:^(UIImage * _Nonnull cropperImage) {
        NSLog(@"233");
        self.imageView.image = cropperImage;
    }];
    [cropper show];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}

@end
