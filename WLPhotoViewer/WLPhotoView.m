//
//  WLPhotoView.m
//  weatherLive
//
//  Created by 卢大维 on 15/7/3.
//  Copyright (c) 2015年 weather. All rights reserved.
//

#import "WLPhotoView.h"
//#import "Masonry.h"
#import "UIView+Extra.h"

@interface WLPhotoView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation WLPhotoView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.userInteractionEnabled = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
//        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(self);
//        }];
        
        self.zoomScale = 1.0f;
        self.maximumZoomScale = 2.0f;
        self.scrollEnabled = NO;
        self.delegate = self;
        
        UITapGestureRecognizer *doubleTapperPhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDoubleTapped:)];
        doubleTapperPhoto.numberOfTapsRequired = 2;
        
        UITapGestureRecognizer *singleTapperPhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSingleTapped:)];
        [singleTapperPhoto requireGestureRecognizerToFail:doubleTapperPhoto];
//        singleTapperPhoto.delegate = self;
        
        [self addGestureRecognizer:singleTapperPhoto];
        [self addGestureRecognizer:doubleTapperPhoto];
    }
    
    return self;
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
}

-(void)resetView
{
    self.contentInset = UIEdgeInsetsZero;
    self.zoomScale = 1.0f;
    self.imageView.frame = self.bounds;
    self.scrollEnabled = NO;
}

- (void)imageDoubleTapped:(UITapGestureRecognizer *)sender {
    
    CGPoint rawLocation = [sender locationInView:sender.view];
    CGPoint point = [self convertPoint:rawLocation fromView:sender.view];
    CGRect targetZoomRect;
    UIEdgeInsets targetInsets;
    if (self.zoomScale == 1.0f) {
        CGFloat zoomWidth = self.bounds.size.width / 2;
        CGFloat zoomHeight = self.bounds.size.height / 2;
        targetZoomRect = CGRectMake(point.x - (zoomWidth/2.0f), point.y - (zoomHeight/2.0f), zoomWidth, zoomHeight);
        targetInsets = [self contentInsetForScrollView:2];
    } else {
        CGFloat zoomWidth = self.bounds.size.width * self.zoomScale;
        CGFloat zoomHeight = self.bounds.size.height * self.zoomScale;
        targetZoomRect = CGRectMake(point.x - (zoomWidth/2.0f), point.y - (zoomHeight/2.0f), zoomWidth, zoomHeight);
        targetInsets = [self contentInsetForScrollView:1.0f];
    }
    self.userInteractionEnabled = NO;
    
    [CATransaction begin];
    __weak typeof(self) weakSelf = self;
    [CATransaction setCompletionBlock:^{
        weakSelf.contentInset = targetInsets;
        weakSelf.userInteractionEnabled = YES;
    }];
    [self zoomToRect:targetZoomRect animated:YES];
    [CATransaction commit];
}

- (void)imageSingleTapped:(id)sender {
    if (self.zoomScale != 1.0) {
        [self resetView];
    }
    [self.photoDelegate dismiss];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
    
    scrollView.scrollEnabled = (scale > 1);
    scrollView.contentInset = [self contentInsetForScrollView:scale];
    if (scale <= 1) {
        self.imageView.center = CGPointMake(self.width/2, self.height/2);
    }
}

- (UIEdgeInsets)contentInsetForScrollView:(CGFloat)targetZoomScale {
    UIEdgeInsets inset = UIEdgeInsetsZero;
    CGFloat boundsHeight = self.bounds.size.height;
    CGFloat boundsWidth = self.bounds.size.width;
    CGFloat contentHeight = (self.image.size.height > 0) ? self.image.size.height : boundsHeight;
    CGFloat contentWidth = (self.image.size.width > 0) ? self.image.size.width : boundsWidth;
    CGFloat minContentHeight;
    CGFloat minContentWidth;
    if (contentHeight > contentWidth) {
        if (boundsHeight/boundsWidth < contentHeight/contentWidth) {
            minContentHeight = boundsHeight;
            minContentWidth = contentWidth * (minContentHeight / contentHeight);
        } else {
            minContentWidth = boundsWidth;
            minContentHeight = contentHeight * (minContentWidth / contentWidth);
        }
    } else {
        if (boundsWidth/boundsHeight < contentWidth/contentHeight) {
            minContentWidth = boundsWidth;
            minContentHeight = contentHeight * (minContentWidth / contentWidth);
        } else {
            minContentHeight = boundsHeight;
            minContentWidth = contentWidth * (minContentHeight / contentHeight);
        }
    }
    CGFloat myHeight = self.bounds.size.height;
    CGFloat myWidth = self.bounds.size.width;
    minContentWidth *= targetZoomScale;
    minContentHeight *= targetZoomScale;
    if (minContentHeight > myHeight && minContentWidth > myWidth) {
        inset = UIEdgeInsetsZero;
    } else {
        CGFloat verticalDiff = boundsHeight - minContentHeight;
        CGFloat horizontalDiff = boundsWidth - minContentWidth;
        verticalDiff = (verticalDiff > 0) ? verticalDiff : 0;
        horizontalDiff = (horizontalDiff > 0) ? horizontalDiff : 0;
        inset.top = verticalDiff/2.0f;
        inset.bottom = verticalDiff/2.0f;
        inset.left = horizontalDiff/2.0f;
        inset.right = horizontalDiff/2.0f;
    }
    return inset;
}
@end
