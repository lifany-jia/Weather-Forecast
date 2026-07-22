//
//  PageViewController.m
//  Weather Forecast
//
//  Created by lifany on 2026/7/21.
//

#import "PageViewController.h"
#import "CityWeatherViewController.h"
#import <Masonry/Masonry.h>
@interface PageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (nonatomic, strong) AllCityWeatherModel *model;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, strong) UIPageControl *page;
@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupButton];
    self.dataSource = self;
    self.delegate = self;
    if (self.model.citys.count == 0) {
        return;
    }
    CityWeatherViewController *initialVC = [[CityWeatherViewController alloc] initWithCityData:self.model.citys[self.startIndex]];
    initialVC.pageIndex = self.startIndex;
    [self setViewControllers:@[initialVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}


- (void)setupButton {
    UIButtonConfiguration *config = [UIButtonConfiguration clearGlassButtonConfiguration];
    config.image = [UIImage systemImageNamed:@"map"];
    config.baseForegroundColor = [UIColor whiteColor];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.configuration = config;
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.view).offset(-40);
            make.height.width.mas_equalTo(45);
    }];
    
    UIButtonConfiguration *pageConfig = [UIButtonConfiguration clearGlassButtonConfiguration];
    UIButton *pagebutton = [UIButton buttonWithType:UIButtonTypeSystem];
    pagebutton.configuration = pageConfig;
    [self.view addSubview:pagebutton];
    [pagebutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(back);
            make.height.mas_equalTo(45);
    }];
    self.page = [[UIPageControl alloc] init];
    self.page.numberOfPages = self.model.citys.count;
    self.page.currentPage = self.startIndex;
    [self.view addSubview:self.page];
    [self.page mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(pagebutton);
            make.left.equalTo(pagebutton).offset(10);
            make.right.equalTo(pagebutton).offset(-10);
    }];
    self.page.userInteractionEnabled = NO;
}
- (instancetype)initWithData:(AllCityWeatherModel *)data index:(NSInteger)index {
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
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
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (!completed) {
        return;
    }
    CityWeatherViewController *currentVC = (CityWeatherViewController *)pageViewController.viewControllers.firstObject;
    self.page.currentPage = currentVC.pageIndex;
    
}
- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
