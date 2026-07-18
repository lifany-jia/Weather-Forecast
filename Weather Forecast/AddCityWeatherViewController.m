//
//  AddCityWeatherViewController.m
//  Weather Forecast
//
//  Created by lifany on 2026/7/16.
//

#import "AddCityWeatherViewController.h"
#import "CityWeatherViewController.h"
#import "WeatherData.h"
#import "WeatherModel.h"
#import <Masonry/Masonry.h>
@interface AddCityWeatherViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<NSDictionary *> *cityLists;
@property (nonatomic, copy) NSDictionary *cityWeatherData;
@property (nonatomic, copy, nullable) dispatch_block_t pendingSearchBlock;
@end

static NSString *const WeatherErrorDomain = @"WeatherError";
@implementation AddCityWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    self.cityLists = @[];
    [self setupSearchBar];
    [self setupTableView];
}
- (void)setupSearchBar {
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.placeholder = @"请输入城市名称";
    self.searchBar.delegate = self;
    // 控制英文输入时不要自动将字母变成大写
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    // 控制系统不要进行自动纠错
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    // 移除 UISearchBar 默认上下边线
    self.searchBar.backgroundImage = [UIImage new];
    self.searchBar.backgroundColor = [UIColor systemGroupedBackgroundColor];
    
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.right.left.equalTo(self.view);
            make.height.mas_equalTo(50);
    }];
}
- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.searchBar.mas_bottom);
            make.right.left.bottom.equalTo(self.view);
    }];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *keyword = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    // GCD写法
    // 没到时间用户有进行输入就取消上一次的防抖任务
    if (self.pendingSearchBlock) {
        dispatch_block_cancel(self.pendingSearchBlock);
        self.pendingSearchBlock = nil;
    }
    if (keyword.length < 1) {
        [[WeatherData sharedInstance] cancelCurrentCitySearch];
        self.cityLists = @[];
        [self.tableView reloadData];
        return;
    }
//    [self performSelector:@selector(filterCitiesWithKeyword:) withObject:keyword afterDelay:0.35];
    __weak typeof(self) weakSelf = self;
    dispatch_block_t searchBlock = dispatch_block_create(0, ^{
        [weakSelf filterCitiesWithKeyword:keyword];
    });
    self.pendingSearchBlock = searchBlock;
    // 约0.25秒之后，把searchBlock提交到主队列执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), searchBlock);
}
- (void)filterCitiesWithKeyword:(NSString *)keyword {
    __weak typeof(self) weakSelf = self;
    [[WeatherData sharedInstance] fetchAssociatedCityNameData:keyword completion:^(NSArray * _Nonnull cityName, NSError * _Nonnull error) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.cityLists = @[];
                    [weakSelf.tableView reloadData];
                });
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.cityLists = cityName ?: @[];
                [weakSelf.tableView reloadData];
            });
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cityLists.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *city = self.cityLists[indexPath.row];
    NSString *name = [city[@"name"] isKindOfClass:[NSString class]] ? city[@"name"] : @"";
    NSString *region = [city[@"region"] isKindOfClass:[NSString class]] ? city[@"region"] : @"";
    NSString *country = [city[@"country"] isKindOfClass:[NSString class]] ? city[@"country"] : @"";
    UIListContentConfiguration *content = [cell defaultContentConfiguration];
    content.text = name;
    if (region.length > 0 && country.length > 0) {
        content.secondaryText =
        [NSString stringWithFormat:@"%@ · %@",
         region,
         country];
    } else if (region.length > 0) {
        content.secondaryText = region;
    } else {
        content.secondaryText = country;
    }
    
    cell.contentConfiguration = content;
    cell.backgroundColor = [UIColor systemBackgroundColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self) weakSelf = self;
    [[WeatherData sharedInstance] fetchCityForecastWeatherData:self.cityLists[indexPath.row][@"name"] completion:^(NSDictionary * _Nonnull dictionary, NSError * _Nonnull error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf handleWeatherError:error];
            });
            return;
        }
        if (!dictionary) {
            NSError *unknowError = [NSError errorWithDomain:WeatherErrorDomain code:-1 userInfo:@{
                NSLocalizedDescriptionKey : @"请求完成，返回天气数据有误"
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf handleWeatherError:unknowError];
            });
            return;
        }
        // 这部分不可以写在该函数下面，因为这一整块都是异步的，不会等这个请求结束就会运行该函数下面的代码，而此时dictionary还没有值
        weakSelf.cityWeatherData = dictionary;
        CityWeather *cityWeather = [[CityWeather alloc] initWithData:self.cityWeatherData];
        // pushViewController 是UIKit操作，必须回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            CityWeatherViewController *city = [[CityWeatherViewController alloc] initWithCityData:cityWeather];
            [strongSelf.navigationController pushViewController:city animated:YES];
        });
    }];
}
- (void)handleWeatherError:(NSError *) error {
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
