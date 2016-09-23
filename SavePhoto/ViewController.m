//
//  ViewController.m
//  SavePhoto
//
//  Created by walg on 16/8/2.
//  Copyright © 2016年 walg. All rights reserved.
//

#import "ViewController.h"
#import "QRcodeManager.h"
@interface ViewController ()
@property (nonatomic, strong) UIImageView *imagView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button1 = [[UIButton alloc]init];
    button1.frame = CGRectMake(50, 100,180, 20);
    button1.backgroundColor = [UIColor clearColor];
    [button1 setTitle:@"保存网络图片" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
    button1.tag = 1;
    [self.view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc]init];
    button2.frame = CGRectMake(200, 100,180, 20);
    button2.backgroundColor = [UIColor clearColor];
    [button2 setTitle:@"保存整页图片" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag = 2;
    [self.view addSubview:button2];
    
    UIButton *button3 = [[UIButton alloc]init];
    button3.frame = CGRectMake(100, 150, 180, 20);
    button3.backgroundColor = [UIColor clearColor];
    [button3 setTitle:@"保存区域图片" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
    button3.tag = 3;
    [self.view addSubview:button3];
    
    NSString *urlstr = @"http://imgsrc.baidu.com/forum/pic/item/503d269759ee3d6d36a7634843166d224e4aded4.jpg";
    NSURL * imageUrl1 = [NSURL URLWithString:[urlstr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSData *data = [NSData dataWithContentsOfURL:imageUrl1];
    UIImage *image = [UIImage imageWithData:data];
    [self.imagView setImage:image];
    [self.view addSubview:self.imagView];
}
-(UIImageView *)imagView{
    if (!_imagView) {
        _imagView = [[UIImageView alloc]init];
        _imagView.frame = CGRectMake(100, 200, 200, 200);
    }
    return _imagView;
}
//
-(void)saveImage:(UIButton*) sender{
    switch (sender.tag) {
        case 1:
        {
            //1,保存网络图片到相册
            NSString *urlStr = @"http://imgsrc.baidu.com/forum/pic/item/503d269759ee3d6d36a7634843166d224e4aded4.jpg";
            [[QRcodeManager sharedInstance] saveImageToPhotosWithUrlStr:urlStr Block:^(BOOL success, NSError *error) {
                NSString *msg ;
                if (success) {
                    msg = @"图片保存成功";
                }else{
                    msg = @"图片保存失败";
                }
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [alertView dismissViewControllerAnimated:YES completion:nil];
                }];
                [alertView addAction:confirmAction];
                [self presentViewController:alertView animated:YES completion:nil];
                
            }];
        }
            break;
        case 2:{
            //2,保存本页到相册
            [[QRcodeManager sharedInstance] saveImageToPhotosWithView:self.view Scale:0 Block:^(BOOL success, NSError *error) {
                NSString *msg ;
                if (success) {
                    msg = @"图片保存成功";
                }else{
                    msg = @"图片保存失败";
                }
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [alertView dismissViewControllerAnimated:YES completion:nil];
                }];
                [alertView addAction:confirmAction];
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
            break;
        case 3:
        {
            //3,选择区域保存本页到相册
            [[QRcodeManager sharedInstance] saveImageToPhotosWithView:self.view Frame:self.view.frame Scale:0 Block:^(BOOL success, NSError *error) {
                NSString *msg ;
                if (success) {
                    msg = @"图片保存成功";
                }else{
                    msg = @"图片保存失败";
                }
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [alertView dismissViewControllerAnimated:YES completion:nil];
                }];
                [alertView addAction:confirmAction];
                [self presentViewController:alertView animated:YES completion:nil];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
