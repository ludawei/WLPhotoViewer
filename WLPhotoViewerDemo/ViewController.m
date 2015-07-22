//
//  ViewController.m
//  WLPhotoViewerDemo
//
//  Created by 卢大维 on 15/7/22.
//  Copyright (c) 2015年 weather. All rights reserved.
//

#import "ViewController.h"
#import "WLPhotoViewController.h"

@interface ViewController ()

@property (nonatomic,strong) NSArray *photos;
@property (nonatomic,strong) NSMutableArray *imageFrames;

@end

@implementation ViewController

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.imageFrames = [NSMutableArray array];
    
    self.photos = @[[UIImage imageNamed:@"1.jpg"], [UIImage imageNamed:@"2.jpg"], [UIImage imageNamed:@"3.jpg"], [UIImage imageNamed:@"4.jpg"]];
    for (NSInteger i=0; i<4; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-100)/2, 80 + 110*i, 100, 100)];
        [button setImage:[self.photos objectAtIndex:i] forState:UIControlStateNormal];
        button.tag = 10 + i;
        [self.view addSubview:button];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect frame = [self.view convertRect:button.frame fromView:self.view];
        [self.imageFrames addObject:[NSValue valueWithCGRect:frame]];
    }
}

-(void)clickButton:(UIButton *)button
{
    WLPhotoViewController *next = [WLPhotoViewController new];
    next.photos = self.photos;
    next.imgFrames = self.imageFrames;
    next.index = button.tag - 10;
    [next showFromController:self withButton:button buttonParentView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
