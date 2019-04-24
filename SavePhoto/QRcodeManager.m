//
//  QRcodeManager.m
//  SavePhoto
//
//  Created by walg on 16/8/2.
//  Copyright © 2016年 walg. All rights reserved.
//

#import "QRcodeManager.h"

@interface QRcodeManager ()

@property (nonatomic, copy) void(^block)(BOOL success, NSError *error);

@end

@implementation QRcodeManager

+ (instancetype)sharedInstance{
    static QRcodeManager *_QRcodeManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _QRcodeManager = [[QRcodeManager alloc]init];
    });
    return _QRcodeManager;
}
/**
 *  传入图片的地址 imageStr
 *  @param ImageStr 图片的地址string
 *  @param block    回调
 */
- (void)saveImageToPhotosWithUrlStr:(NSString*)ImageStr Block:(void(^)(BOOL success,NSError *error))block
{
    _block = block;
    NSURL * imageUrl = [NSURL URLWithString:[ImageStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSData *data   = [NSData dataWithContentsOfURL:imageUrl];
    UIImage *image = [UIImage imageWithData:data];
    [self saveImageToPhotos:image];
}
/**
 *  切割图片，但是这种方式只能是切割以[UIimage imagename：]这种方式获取的
 *  @param image UIImage *image = [UIImage imageNamed:@""];
 *  @param frame 要截取的部位
 *  @return
 */
- (void)saveImageToPhotosWithImage:(UIImage *)image Frame:(CGRect)frame Block:(void(^)(BOOL success,NSError *error))block
{
    _block = block;
    UIImage *subImage = [self subImage:image Frame:frame];
    [self saveImageToPhotos:subImage];
}
/**
 *   保存可选是否透明的图片
 *  @param view   要保存的view
 *  @param scale  缩放比例
 */
- (void)saveImageToPhotosWithView:(UIView*)view Scale:(CGFloat)scale Block:(void(^)(BOOL success,NSError *error))block
{
    _block = block;
    UIImage *scaleImage = [self converToImageWithView:view Opaque:NO Scale:scale];
    [self saveImageToPhotos:scaleImage];
}

- (void)saveImageToPhotosWithView:(UIView*)view Frame:(CGRect)frame Scale:(CGFloat)scale Block:(void(^)(BOOL success,NSError *error))block
{
    _block = block;
    UIImage *scaleImage = [self converToImageWithView:view Opaque:NO Scale:scale];
    UIImage *subImage = [self subImage:scaleImage Frame:frame];
    [self saveImageToPhotos:subImage];
}
/**
 *  保存可选是否透明的图片
 *  @param view   要保存的view
 *  @param opaque 是否透明
 *  @param scale  缩放比例
 */
- (void)saveImageToPhotosWithView:(UIView*)view Opaque:(BOOL)opaque Scale:(CGFloat)scale Block:(void(^)(BOOL success,NSError *error))block
{
    _block = block;
    UIImage *scaleImage = [self converToImageWithView:view Opaque:opaque Scale:scale];
    [self saveImageToPhotos:scaleImage];
}
/**
 *  将view转换成image
 *  @param view   要转化的view
 *  @param opaque 是否透明
 *  @param scale  以sacle比例压缩图片
 *  @return
 */
- (UIImage *)converToImageWithView:(UIView*)view Opaque:(BOOL)opaque Scale:(CGFloat)scale
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, opaque, scale);//获取上下文
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *copyImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return copyImage;
}

- (UIImage*)subImage:(UIImage*)image Frame:(CGRect)frame
{
    CGImageRef subCGImage = CGImageCreateWithImageInRect(image.CGImage, frame);
    UIImage *subImage = [UIImage imageWithCGImage:subCGImage];
    CGImageRelease(subCGImage);
    return subImage;
}

- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error != NULL) {
        _block(NO,error);
    } else {
        _block(YES,nil);
    }
}

+ (UIImage *)snapshotWithFrame:(CGRect)snapFrame inView:(UIView *)view
{
    UIImage * targetIamge = nil;
    CGFloat offsetY = 0;
    CGFloat offsetX = 0;
    CGRect  oldFrame  = view.frame;
    CGPoint oldOffset = CGPointZero;
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView * scrollView = (UIScrollView *)view;
        oldOffset = scrollView.contentOffset;
        offsetY   = oldOffset.y;
        offsetX   = oldOffset.x;
        [scrollView setFrame:CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height)];
        [scrollView setContentOffset:CGPointZero];
    }
    UIGraphicsBeginImageContextWithOptions(snapFrame.size, YES, 0);
    CGRect drawRect = CGRectMake(- CGRectGetMinX(snapFrame) + offsetX, - CGRectGetMinY(snapFrame) + offsetY, view.bounds.size.width, view.bounds.size.height);
    [view drawViewHierarchyInRect:drawRect afterScreenUpdates:YES];
    targetIamge = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView * scrollView = (UIScrollView *)view;
        scrollView.contentOffset  = oldOffset;
        scrollView.frame          = oldFrame;
    }
    
    return targetIamge;
}

@end
