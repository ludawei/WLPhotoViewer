//
//  WLPhotoViewController.m
//  weatherLive
//
//  Created by 卢大维 on 15/7/3.
//  Copyright (c) 2015年 weather. All rights reserved.
//

#import "WLPhotoViewController.h"
#import "WLPhotoView.h"
#import "UIView+Extra.h"
#import "VICMAImageView.h"

#define GAP_WIDTH 20.0f

@interface WLPhotoViewController ()<UIScrollViewDelegate, WLPhotoViewDelegate>
{
    BOOL isLoaded;
}

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSMutableArray *photoViews;

@end

@implementation WLPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width+GAP_WIDTH, self.view.height)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.height*0.9, self.view.width, 10)];
    self.pageControl.numberOfPages = self.photos.count;
    [self.view addSubview:self.pageControl];
    
    [self initPhotoViews];
}

-(void)initPhotoViews
{
    self.photoViews = [NSMutableArray arrayWithCapacity:self.photos.count];
    for (NSInteger i=0; i<self.photos.count; i++) {
        
        WLPhotoView *photoView = [[WLPhotoView alloc] initWithFrame:CGRectMake(self.scrollView.width*i, 0, self.scrollView.width-GAP_WIDTH, self.scrollView.height)];
        photoView.photoDelegate = self;
        photoView.image = [self.photos objectAtIndex:i];
        [self.scrollView addSubview:photoView];
        
        [self.photoViews addObject:photoView];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width*self.photos.count, self.scrollView.height);
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width*self.index, 0)];
    self.pageControl.currentPage = self.index;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.pageControl.frame = CGRectMake(0, self.view.height*0.9, self.view.width, 10);
    
    self.scrollView.frame = CGRectMake(0, 0, self.view.width+GAP_WIDTH, self.view.height);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width*self.photos.count, self.scrollView.height);
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width*self.pageControl.currentPage, 0)];
    
    [self.photoViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        WLPhotoView *photoView = (WLPhotoView *)obj;
        photoView.frame = CGRectMake(self.scrollView.width*idx, 0, self.scrollView.width-GAP_WIDTH, self.scrollView.height);
        [photoView resetView];
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    isLoaded = YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (isLoaded) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x/scrollView.width;
    if (page != self.pageControl.currentPage) {
        
        WLPhotoView *photoView = [self.photoViews objectAtIndex:self.pageControl.currentPage];
        [photoView resetView];
        
        self.pageControl.currentPage = page;
    }
}

#pragma mark - WLPhotoViewDelegate
-(void)dismiss
{
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor blackColor];
    [[[UIApplication sharedApplication] keyWindow] addSubview:backView];
    
    NSInteger page = self.pageControl.currentPage;
    UIImage *image = [self.photos objectAtIndex:page];
    
    CGFloat radio = self.view.width/image.size.width;
    CGSize imgSize = CGSizeMake(image.size.width * radio, image.size.height *radio);
    
    VICMAImageView *imgView = [[VICMAImageView alloc] initWithFrame:CGRectMake(0, (self.scrollView.height-imgSize.height)/2, imgSize.width, imgSize.height)];
    imgView.image = image;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [[[UIApplication sharedApplication] keyWindow] addSubview:imgView];
    
    [self dismissViewControllerAnimated:NO completion:^{
        
        [UIView animateWithDuration:0.3 animations:^{
            backView.alpha = 0;
            imgView.frame = [[self.imgFrames objectAtIndex:page] CGRectValue];
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
            [imgView removeFromSuperview];
        }];
    }];
}

-(void)showFromController:(UIViewController *)controller withButton:(UIView *)button buttonParentView:(UIView *)parentView
{
    self.view.hidden = YES;
    
    [controller presentViewController:self animated:NO completion:^{
        
        NSInteger page = self.index;
        UIImage *image = [self.photos objectAtIndex:page];
        
        VICMAImageView *imgView = [[VICMAImageView alloc] initWithFrame:[controller.view convertRect:button.frame fromView:parentView]];
        imgView.image = image;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [[[UIApplication sharedApplication] keyWindow] addSubview:imgView];
        
        CGFloat radio = controller.view.width/image.size.width;
        CGSize imgSize = CGSizeMake(image.size.width * radio, image.size.height *radio);
        CGRect toFrame = CGRectMake(0, (controller.view.height-imgSize.height)/2, imgSize.width, imgSize.height);
        
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            imgView.frame = toFrame;
        } completion:^(BOOL finished) {
            [imgView removeFromSuperview];
            self.view.hidden = NO;
        }];
    }];
}
@end
