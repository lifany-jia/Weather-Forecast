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
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *addCity = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCityWeather)];
    self.navigationItem.leftBarButtonItem = addCity;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
