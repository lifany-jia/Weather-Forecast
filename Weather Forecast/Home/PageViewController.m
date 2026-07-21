//
//  PageViewController.m
//  Weather Forecast
//
//  Created by lifany on 2026/7/21.
//

#import "PageViewController.h"
#import "CityWeatherViewController.h"
@interface PageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (nonatomic, strong) AllCityWeatherModel *model;
@property (nonatomic, assign) NSInteger startIndex;
@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    [appearance configureWithDefaultBackground];
    appearance.shadowColor = [UIColor clearColor];
    self.navigationItem.standardAppearance = appearance;
    self.navigationItem.scrollEdgeAppearance = appearance;
    self.navigationItem.compactAppearance = appearance;
    
    self.dataSource = self;
    self.delegate = self;
    if (self.model.citys.count == 0) {
        return;
    }
    CityWeatherViewController *initialVC = [[CityWeatherViewController alloc] initWithCityData:self.model.citys[self.startIndex]];
    initialVC.pageIndex = self.startIndex;
    [self setViewControllers:@[initialVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}
- (instancetype)initWithData:(AllCityWeatherModel *)data index:(NSInteger)index {
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    if (self) {
        self.model = data;
        self.startIndex = index;
    }
    return self;
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    CityWeatherViewController *currentVC = (CityWeatherViewController *)viewController;
    NSInteger nextIndex = currentVC.pageIndex + 1;
    if (nextIndex >= self.model.citys.count) {
        return nil;
    }
    CityWeatherViewController *nextVC = [[CityWeatherViewController alloc] initWithCityData:self.model.citys[nextIndex]];
    nextVC.pageIndex = nextIndex;
    return nextVC;
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (![viewController isKindOfClass:[CityWeatherViewController class]]) {
        return nil;
    }
    CityWeatherViewController *currentVC = (CityWeatherViewController *)viewController;
    NSInteger prevIndex = currentVC.pageIndex - 1;
    if (prevIndex < 0) {
        return nil;
    }
    CityWeatherViewController *prevVC = [[CityWeatherViewController alloc] initWithCityData:self.model.citys[prevIndex]];
    prevVC.pageIndex = prevIndex;
    return prevVC;
}

@end
