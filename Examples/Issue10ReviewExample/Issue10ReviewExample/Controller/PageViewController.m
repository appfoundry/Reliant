//
// Created by Alex Manarpies on 05/12/15.
// Copyright (c) 2015 Reliant. All rights reserved.
//

#import "PageViewController.h"

@interface PageViewController () <UIPageViewControllerDataSource>
@property(nonatomic, strong) NSArray<UIViewController *> *pages;
@end

@implementation PageViewController

- (NSArray<UIViewController *> *)pages {
    return _pages ?: (_pages = @[
            [self.storyboard instantiateViewControllerWithIdentifier:@"RandomViewController"],
            [self.storyboard instantiateViewControllerWithIdentifier:@"RandomViewController"],
    ]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    [self setViewControllers:[self.pages subarrayWithRange:NSMakeRange(0, 1)]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:^(BOOL finished) {
                  }];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.pages indexOfObject:viewController];
    NSInteger previousIndex = index - 1;
    return previousIndex >= 0 ? self.pages[(NSUInteger) previousIndex] : nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.pages indexOfObject:viewController];
    NSInteger nextIndex = index + 1;
    return nextIndex < self.pages.count ? self.pages[(NSUInteger) nextIndex] : nil;
}

@end