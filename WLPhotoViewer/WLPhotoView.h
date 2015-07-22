//
//  WLPhotoView.h
//  weatherLive
//
//  Created by 卢大维 on 15/7/3.
//  Copyright (c) 2015年 weather. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WLPhotoViewDelegate <NSObject>

-(void)dismiss;

@end

@interface WLPhotoView : UIScrollView

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,weak) id<WLPhotoViewDelegate> photoDelegate;

-(void)resetView;

@end
