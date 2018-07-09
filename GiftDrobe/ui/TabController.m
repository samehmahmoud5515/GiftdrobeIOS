//
//  TabController.m
//  GiftDrobe
//
//  Created by Logic Designs on 6/7/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TabController.h"

@interface TabController ()

@end

@implementation TabController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    //[self.tabBar invalidateIntrinsicContentSize];
    self.tabBarController.tabBar.hidden = NO;

    CGFloat tabSize = 49.0;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
  
    
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        tabSize = 32.0;
    }
 
    self.tabBar.frame = CGRectMake(0,0,self.view.frame.size.width, tabSize);
    self.parentViewController.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tabBar.translucent = NO;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tabBarController.tabBar.hidden = YES;
}



@end
