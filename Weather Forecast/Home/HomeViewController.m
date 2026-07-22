//
//  HomeViewController.m
//  Weather Forecast
//
//  Created by lifany on 2026/7/15.
//

#import "HomeViewController.h"
#import "CityWeatherCell.h"
#import "CityWeatherViewController.h"
#import "PageViewController.h"
#import "AllCityWeatherModel.h"
#import "WeatherData.h"
#import <Masonry/Masonry.h>
@interface HomeViewController () <UISearchResultsUpdating, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AllCityWeatherModel *model;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *array;
@property (nonatomic, strong) UIBarButtonItem *barButton;
@property (nonatomic, strong) UIBarButtonItem *finishButton;
@property (nonatomic, strong) UILabel *weatherTitle;

// 添加天气搜索框部分
//@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchController *search;
@property (nonatomic, strong) UITableView *tableViewSearch;
@property (nonatomic, copy) NSArray<NSDictionary *> *cityLists;
@property (nonatomic, copy) NSDictionary *cityWeatherData;
@property (nonatomic, copy, nullable) dispatch_block_t pendingSearchBlock;
@end

static NSString *const WeatherErrorDomain = @"WeatherError";

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    [self setupTitle];
    [self setupBarButton];
    self.cityLists = @[];
    [self setupSearchController];
    [self setupSearchTableView];
    self.model = [AllCityWeatherModel sharedInstance];
    // 先清空后添加，防止viewDidLoad重复调用
    [self.model.citys removeAllObjects];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:KCityArrayKey];
    NSLog(@"array = %ld", array.count);
    __weak typeof(self) weakSelf = self;
    dispatch_group_t group = dispatch_group_create();
    // 用字典按城市名暂存请求结果，解决异步回调顺序不确定导致索引错位的问题
    NSMutableDictionary<NSString *, CityWeatherModel *> *resultMap = [NSMutableDictionary dictionary];
    for (int i = 0; i < array.count; i++) {
        dispatch_group_enter(group);
        NSString *cityName = array[i];
        [[WeatherData sharedInstance] fetchCityForecastWeatherData:cityName completion:^(NSDictionary * _Nonnull dictionary, NSError * _Nonnull error) {
            if (error) {
                   NSLog(@"请求失败: %@, error: %@", cityName, error);
               }
            if (!error && dictionary) {
                CityWeatherModel *cityWeather = [[CityWeatherModel alloc] initWithData:dictionary];
                @synchronized (resultMap) {
                    resultMap[cityName] = cityWeather;
                }
            }
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 按 NSUserDefaults 的顺序从字典取出数据，保证 citys 和 NSUserDefaults 索引严格一致
        for (NSString *cityName in array) {
            CityWeatherModel *model = resultMap[cityName];
            if (model) {
                [weakSelf.model.citys addObject:model];
            }
        }
        [weakSelf setupTableView];
    });
}
- (void)setupTitle {
    self.weatherTitle = [[UILabel alloc] init];
    self.weatherTitle.text = @"天气";
    self.weatherTitle.textColor = [UIColor labelColor];
    self.weatherTitle.font = [UIFont boldSystemFontOfSize:35];
    [self.view addSubview:self.weatherTitle];
    [self.weatherTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view).offset(23);
    }];
}
#pragma mark Menu
- (void)setupBarButton {
    self.array = [NSMutableArray array];
    [self.array addObject:@(1)];
    [self.array addObject:@(1)];
    self.barButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"ellipsis"] menu:[self buildMenu]];
    self.navigationItem.rightBarButtonItem = self.barButton;
    self.finishButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"checkmark"] style:UIBarButtonItemStylePlain target:self action:@selector(finishEdit)];
}
- (UIMenu *)buildMenu {
    __weak typeof(self) weakSelf = self;
    UIAction *edit = [UIAction actionWithTitle:@"编辑列表" image:[UIImage systemImageNamed:@"pencil"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        [strongSelf editCitys];
    }];
    UIAction *bell = [UIAction actionWithTitle:@"通知" image:[UIImage systemImageNamed:@"bell"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        NSInteger currentIndex = [weakSelf.array[0] integerValue];
        NSInteger newIndex = currentIndex == 0 ? 1 : 0;
        strongSelf.array[0] = @(newIndex);
        [strongSelf refreshMenu];
    }];
    bell.state = [self.array[0] integerValue];
    UIAction *celsius = [UIAction actionWithTitle:@"摄氏度" image:[UIImage systemImageNamed:@"degreesign.celsius"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        NSInteger currentIndex = [weakSelf.array[1] integerValue];
        NSInteger newIndex = currentIndex == 0 ? 1 : 0;
        strongSelf.array[1] = @(newIndex);
        [strongSelf refreshMenu];
    }];
    celsius.state = [self.array[1] integerValue];
    UIMenu *menu = [UIMenu menuWithTitle:@"" children:@[edit, bell, celsius]];
    return menu;
}
- (void)refreshMenu {
    self.barButton.menu = [self buildMenu];
}

#pragma mark CityTableView
- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}
- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 125;
    self.tableView.backgroundColor = [UIColor systemGroupedBackgroundColor];
    [self.tableView registerClass:[CityWeatherCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.weatherTitle.mas_bottom);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableViewSearch) {
        return self.cityLists.count;
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableViewSearch) {
        return 1;
    }
    return self.model.citys.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableViewSearch) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        NSDictionary *city = self.cityLists[indexPath.row];
        NSString *name = [city[@"name"] isKindOfClass:[NSString class]] ? city[@"name"] : @"";
        NSString *region = [city[@"region"] isKindOfClass:[NSString class]] ? city[@"region"] : @"";
        NSString *country = [city[@"country"] isKindOfClass:[NSString class]] ? city[@"country"] : @"";
        UIListContentConfiguration *content = [cell defaultContentConfiguration];
        content.text = name;
        if (region.length > 0 && country.length > 0) {
            content.secondaryText = [NSString stringWithFormat:@"%@ · %@", region, country];
        } else if (region.length > 0) {
            content.secondaryText = region;
        } else {
            content.secondaryText = country;
        }
        cell.contentConfiguration = content;
        cell.backgroundColor = [UIColor systemBackgroundColor];
        return cell;
    }

    CityWeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell updateWithData:self.model.citys[indexPath.section]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableViewSearch) {
        [self fetchWeatherForSearchResultAtIndexPath:indexPath];
        return;
    }
    PageViewController *page = [[PageViewController alloc] initWithData:self.model index:indexPath.section];
    page.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:page animated:YES completion:nil];
}

- (void)editCitys {
    [self.tableView setEditing:YES animated:YES];
    self.navigationItem.rightBarButtonItem = self.finishButton;
}
- (void)finishEdit {
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem = self.barButton;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.model removeCity:indexPath.section];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
//-(UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UIContextualAction* deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
//        NSInteger index = indexPath.section;
//        [SavedCityStore removeCity:self.cityModelArray[index]];
//        [self.cityModelArray removeObjectAtIndex:index];
//        [self.WeatherModelArray removeObjectAtIndex:index];
//        [tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
//        completionHandler(YES);
//    }];
//    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
//    config.performsFirstActionWithFullSwipe = YES;
//    return config;
//}
#pragma mark SearchController
- (void)setupSearchController {
    self.search = [[UISearchController alloc] initWithSearchResultsController:nil];
    // 这里代替了原来的 self.searchBar.delegate = self
    // 只不过输入变化不再走 UISearchBarDelegate 的 textDidChange，
    // 而是走 UISearchResultsUpdating 的 updateSearchResultsForSearchController:
    self.search.searchResultsUpdater = self;
//    self.search.obscuresBackgroundDuringPresentation = NO;
    self.search.searchBar.placeholder = @"搜索城市";
    self.search.searchBar.delegate = self;
    self.search.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.search.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    // 不再用 addSubview + mas_makeConstraints 手动摆位，
    // 而是交给导航栏管理
    self.navigationItem.searchController = self.search;
    // 一直显示搜索框，不随滚动隐藏
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    self.definesPresentationContext = YES;
    
//    self.searchBar = [[UISearchBar alloc] init];
//    self.searchBar.placeholder = @"请输入城市名称";
//    self.searchBar.delegate = self;
//    // 控制英文输入时不要自动将字母变成大写
//    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    // 控制系统不要进行自动纠错
//    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
//    // 移除 UISearchBar 默认上下边线
//    self.searchBar.backgroundImage = [UIImage new];
//    self.searchBar.backgroundColor = [UIColor systemGroupedBackgroundColor];
//
//    [self.view addSubview:self.searchBar];
//    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
//            make.right.left.equalTo(self.view);
//            make.height.mas_equalTo(50);
//    }];
}
- (void)setupSearchTableView {
    self.tableViewSearch = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    self.tableViewSearch.delegate = self;
    self.tableViewSearch.dataSource = self;
    self.tableViewSearch.backgroundColor = [UIColor systemGroupedBackgroundColor];
    self.tableViewSearch.hidden = YES;
    [self.tableViewSearch registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableViewSearch];
    [self.tableViewSearch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.right.left.bottom.equalTo(self.view);
    }];
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *keyword = [searchController.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
           self.tableViewSearch.hidden = YES;
           [self.tableViewSearch reloadData];
           return;
       }
       self.tableViewSearch.hidden = NO;
       [self.view bringSubviewToFront:self.tableViewSearch];
   //    [self performSelector:@selector(filterCitiesWithKeyword:) withObject:keyword afterDelay:0.35];
       __weak typeof(self) weakSelf = self;
       dispatch_block_t searchBlock = dispatch_block_create(0, ^{
           [weakSelf filterCitiesWithKeyword:keyword];
       });
       self.pendingSearchBlock = searchBlock;
       // 约0.25秒之后，把searchBlock提交到主队列执行
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), searchBlock);
}
// UISearchBar写在这个函数里
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText

- (void)filterCitiesWithKeyword:(NSString *)keyword {
    __weak typeof(self) weakSelf = self;
    [[WeatherData sharedInstance] fetchAssociatedCityNameData:keyword completion:^(NSArray * _Nonnull cityName, NSError * _Nonnull error) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.cityLists = @[];
                    weakSelf.tableViewSearch.hidden = YES;
                    [weakSelf.tableViewSearch reloadData];
                });
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.cityLists = cityName ?: @[];
                weakSelf.tableViewSearch.hidden = weakSelf.cityLists.count == 0;
                [weakSelf.tableViewSearch reloadData];
            });
    }];
}
- (void)fetchWeatherForSearchResultAtIndexPath:(NSIndexPath *)indexPath {
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
        CityWeatherModel *cityWeather = [[CityWeatherModel alloc] initWithData:self.cityWeatherData];
        // pushViewController 是UIKit操作，必须回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            CityWeatherViewController *city = [[CityWeatherViewController alloc] initWithCityData:cityWeather];
            [strongSelf.navigationController pushViewController:city animated:YES];
        });
    }];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *keyword = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (keyword.length == 0) {
        return;
    }

    if (self.pendingSearchBlock) {
        dispatch_block_cancel(self.pendingSearchBlock);
        self.pendingSearchBlock = nil;
    }

    if (self.cityLists.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self fetchWeatherForSearchResultAtIndexPath:indexPath];
        return;
    }

    __weak typeof(self) weakSelf = self;
    [[WeatherData sharedInstance] fetchAssociatedCityNameData:keyword completion:^(NSArray * _Nonnull cityName, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf || error || cityName.count == 0) {
                return;
            }

            strongSelf.cityLists = cityName;
            strongSelf.tableViewSearch.hidden = NO;
            [strongSelf.tableViewSearch reloadData];
            NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:0 inSection:0];
            [strongSelf fetchWeatherForSearchResultAtIndexPath:indexPath];
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
