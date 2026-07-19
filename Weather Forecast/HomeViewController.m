//
//  HomeViewController.m
//  Weather Forecast
//
//  Created by lifany on 2026/7/15.
//

#import "HomeViewController.h"
#import "CityWeatherCell.h"
#import "AddCityWeatherViewController.h"
#import "CityWeatherViewController.h"
#import "WeatherModel.h"
#import "WeatherData.h"
@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WeatherModel *model;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *array;
@property (nonatomic, strong) UIBarButtonItem *barButton;
@property (nonatomic, strong) UIBarButtonItem *finishButton;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBarButton];
    self.model = [WeatherModel sharedInstance];
    __weak typeof(self) weakSelf = self;
    [[WeatherData sharedInstance] fetchCityForecastWeatherData:@"西安" completion:^(NSDictionary * _Nonnull dictionary, NSError * _Nonnull error) {
        if (error) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            CityWeather *cityWeather = [[CityWeather alloc] initWithData:dictionary];
            [weakSelf.model.citys addObject:cityWeather];
            [self setupTableView];
        });
    }];
}
- (void)setupBarButton {
    self.array = [NSMutableArray array];
    [self.array addObject:@(1)];
    [self.array addObject:@(1)];
    self.barButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"ellipsis"] menu:[self buildMenu]];
    self.navigationItem.rightBarButtonItem = self.barButton;
    UIBarButtonItem *addCity = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCityWeather)];
    self.navigationItem.leftBarButtonItem = addCity;
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
- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}
- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
    self.tableView.backgroundColor = [UIColor systemBackgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor systemGroupedBackgroundColor];
    [self.tableView registerClass:[CityWeatherCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.model.citys.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CityWeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell updateWithData:self.model.citys[indexPath.section]];
    return cell;
}
- (void)addCityWeather {
    AddCityWeatherViewController *addCityWeather = [[AddCityWeatherViewController alloc] init];
    [self.navigationController pushViewController:addCityWeather animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CityWeatherViewController *city = [[CityWeatherViewController alloc] initWithCityData:self.model.citys[indexPath.section]];
    [self presentViewController:city animated:YES completion:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;   // 原来可能是 20~35
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
