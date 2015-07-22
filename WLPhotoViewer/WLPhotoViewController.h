//
//  WLPhotoViewController.h
//  weatherLive
//
//  Created by 卢大维 on 15/7/3.
//  Copyright (c) 2015年 weather. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLPhotoViewController : UIViewController

@property (nonatomic,strong) NSArray *photos;
@property (nonatomic,strong) NSArray *imgFrames;
@property (nonatomic,assign) NSInteger index;

-(void)showFromController:(UIViewController *)controller withButton:(UIView *)button buttonParentView:(UIView *)parentView;

@end
