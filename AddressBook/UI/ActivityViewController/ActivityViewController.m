//
//  ActivityViewController.m
//  AddressBook
//
//  Created by Mac on 06.07.16.
//  Copyright © 2016 ta. All rights reserved.
//

#import "ActivityViewController.h"

@interface ActivityViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createActivityIndicator];
}

- (void)createActivityIndicator {
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

- (void)showActivityView {
    [self showActivityViewInView:self.view];
}

- (void)showActivityViewInView:(UIView *)inView {
    if ([NSThread isMainThread]) {
        [self startAnimatingActivity:inView];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startAnimatingActivity:inView];
        });
    }
}

- (void)startAnimatingActivity:(UIView *)inView {
    self.activityView.frame = inView.bounds;
    self.activityView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.activityView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.activityView.hidden = NO;
    self.activityView.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    
    [inView addSubview:self.activityView];
    [self.activityView startAnimating];
}

- (void)hideActivityView {
    if ([NSThread isMainThread]) {
        [self stopAnimatingActivity];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopAnimatingActivity];
        });
    }
}

- (void)stopAnimatingActivity {
    [self.activityView stopAnimating];
    [self.activityView removeFromSuperview];
    self.view.userInteractionEnabled = YES;
}

@end
