//
//  CityWeatherViewController.m
//  Weather Forecast
//
//  Created by lifany on 2026/7/16.
//

#import "CityWeatherViewController.h"
#import "AllCityWeatherModel.h"
#import "WeatherCardCell.h"
#import "WeatherCardsModel.h"
#import "HourCardCell.h"
#import "WeekCardCell.h"
#import "SquareCardCell.h"
#import <Masonry/Masonry.h>
@interface CityWeatherViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) CityWeatherModel *cityData;
@property (nonatomic, strong) WeatherCardsModel *weatherCards;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *cityName;
@property (nonatomic, strong) UILabel *temperature;
@property (nonatomic, strong) UILabel *maxmin_temperature;
@property (nonatomic, strong) UILabel *weather;
@property (nonatomic, strong) UILabel *navigationLabel;
@end

@implementation CityWeatherViewController
- (instancetype)initWithCityData:(CityWeatherModel *)cityData {
    self = [super init];
    if (self) {
        self.cityData = cityData;
        self.weatherCards = [WeatherCardsModel sharedInstance];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[AllCityWeatherModel sharedInstance] isCityInModel:self.cityData.city]) {
        UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCity)];
        self.navigationItem.rightBarButtonItem = add;
    } else {
        UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"trash"] style:UIBarButtonItemStylePlain target:self action:@selector(removeCity)];
        self.navigationItem.rightBarButtonItem = delete;
    }
    
    UIImageView *backGroudView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.cityData.weatherBackImage]];
    backGroudView.contentMode = UIViewContentModeScaleAspectFill;
    backGroudView.clipsToBounds = YES;
    [self.view addSubview:backGroudView];
    [self.view sendSubviewToBack:backGroudView];
    [backGroudView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
    }];
    [self setupNavigationTitle];
    [self setupHeaderView];
    [self setupTableView];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // alpha = 0 设置得太早，push 过程中，导航栏会重新布局、生成/更新自己的内部视图，所以alpha=0可能被覆盖掉
    // 所以在 viewDidLayoutSubviews 或 viewDidAppear 再按当前滚动位置强制同步一次 alpha/hidden
    [self updateHeaderAlphaWithScrollView:self.tableView];
}
- (void)setupNavigationTitle {
    self.navigationLabel = [[UILabel alloc] init];
    self.navigationLabel.backgroundColor = [UIColor clearColor];
    self.navigationLabel.text = self.cityData.city;
    self.navigationLabel.font = [UIFont systemFontOfSize:30];
    self.navigationLabel.textColor = [UIColor systemBackgroundColor];
    self.navigationLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationLabel.alpha = 0.0;
    self.navigationLabel.hidden = YES;
    self.navigationItem.titleView = self.navigationLabel;
}
- (void)setupHeaderView {
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 275)];
    self.cityName = [[UILabel alloc] init];
    self.cityName.textColor = [UIColor systemBackgroundColor];
    self.cityName.font = [UIFont systemFontOfSize:30];
    self.cityName.text = self.cityData.city;
    self.cityName.alpha = 1;
    [self.headerView addSubview:self.cityName];
    [self.cityName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView).offset(20);
            make.centerX.equalTo(self.headerView);
    }];
    
    self.temperature = [[UILabel alloc] init];
    NSString *weatherText = [NSString stringWithFormat:@"%ld°", (long)self.cityData.temperature];
    self.temperature.textColor = [UIColor systemBackgroundColor];
    self.temperature.text = weatherText;
    self.temperature.alpha = 1;
    self.temperature.font = [UIFont boldSystemFontOfSize:120];
    [self.headerView addSubview:self.temperature];
    [self.temperature mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cityName.mas_bottom).offset(3);
            make.centerX.equalTo(self.headerView).offset(20);
    }];
    
    self.maxmin_temperature = [[UILabel alloc] init];
    NSString *maxminText = [NSString stringWithFormat:@"%ld° / %ld°", (long)self.cityData.min_temperature, (long)self.cityData.max_temperature];
    self.maxmin_temperature.textColor = [UIColor systemBackgroundColor];
    self.maxmin_temperature.text = maxminText;
    self.maxmin_temperature.alpha = 1;
    self.maxmin_temperature.font = [UIFont boldSystemFontOfSize:20];
    [self.headerView addSubview:self.maxmin_temperature];
    [self.maxmin_temperature mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.temperature.mas_bottom).offset(-10);
            make.centerX.equalTo(self.headerView);
    }];
    
    self.weather = [[UILabel alloc] init];
    self.weather.textColor = [UIColor systemBackgroundColor];
    self.weather.text = self.cityData.weather;
    [self.headerView addSubview:self.weather];
    self.weather.alpha = 1;
    self.weather.font = [UIFont boldSystemFontOfSize:20];
    [self.weather mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.maxmin_temperature.mas_bottom);
            make.centerX.equalTo(self.headerView);
    }];
}
- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    self.tableView.layer.cornerRadius = 20;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[WeatherCardCell class] forCellReuseIdentifier:AirQualityCellIdentifier];
    [self.tableView registerClass:[WeatherCardCell class] forCellReuseIdentifier:SunCellIdentifier];
    [self.tableView registerClass:[WeatherCardCell class] forCellReuseIdentifier:MoonCellIdentifier];
    [self.tableView registerClass:[HourCardCell class] forCellReuseIdentifier:HourCellIdentifier];
    [self.tableView registerClass:[WeekCardCell class] forCellReuseIdentifier:WeekCellIdentifier];
    [self.tableView registerClass:[SquareCardCell class] forCellReuseIdentifier:SquareCellIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.bottom.equalTo(self.view);
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.weatherCards.cardLists.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        WeatherCardCell *cell = [tableView dequeueReusableCellWithIdentifier:AirQualityCellIdentifier forIndexPath:indexPath];
        [cell updateWithAirData:self.cityData];
        return cell;
    } else if (indexPath.section == 4) {
        WeatherCardCell *cell = [tableView dequeueReusableCellWithIdentifier:SunCellIdentifier forIndexPath:indexPath];
        [cell updateWithSunData:self.cityData];
        return cell;
    } else if (indexPath.section == 5) {
        WeatherCardCell *cell = [tableView dequeueReusableCellWithIdentifier:MoonCellIdentifier forIndexPath:indexPath];
        [cell updateWithMoonData:self.cityData];
        return cell;
    } else if (indexPath.section == 0) {
        HourCardCell *cell = [tableView dequeueReusableCellWithIdentifier:HourCellIdentifier forIndexPath:indexPath];
        [cell updateWithData:self.cityData.currNextHourWeather];
        return cell;
    } else if (indexPath.section == 1) {
        WeekCardCell *cell = [tableView dequeueReusableCellWithIdentifier:WeekCellIdentifier forIndexPath:indexPath];
        [cell updateWithData:self.cityData.weekWeather];
        return cell;
    } else if (indexPath.section == 3) {
        SquareCardCell *cell = [tableView dequeueReusableCellWithIdentifier:SquareCellIdentifier forIndexPath:indexPath];
        [cell updateWithData:self.cityData];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateHeaderAlphaWithScrollView:scrollView];
}
- (void)updateHeaderAlphaWithScrollView:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y + scrollView.adjustedContentInset.top;
    offset = MAX(0, offset);
    // 避免 alpha 超过 1
    CGFloat progressCity = MIN(offset / 74.0, 1.0);
    self.cityName.alpha = 1.0 - progressCity;
    self.navigationLabel.alpha = progressCity;
    self.navigationLabel.hidden = progressCity <= 0.0;

    CGFloat progressTemp = MIN(offset / 184.0, 1.0);
    self.temperature.alpha = 1.0 - progressTemp;

    CGFloat progressWeather = MIN(offset / 248.0, 1.0);
    self.maxmin_temperature.alpha = 1.0 - progressWeather;
    self.weather.alpha = 1.0 - progressWeather;
}
- (void)addCity {
    [[AllCityWeatherModel sharedInstance] addCity:self.cityData];
    [self pushAlert:@"已添加到收藏"];
    UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"trash"] style:UIBarButtonItemStylePlain target:self action:@selector(removeCity)];
    self.navigationItem.rightBarButtonItem = delete;
}
- (void)removeCity {
    [[AllCityWeatherModel sharedInstance] removeCityWithData:self.cityData];
    [self pushAlert:@"已删除"];
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCity)];
    self.navigationItem.rightBarButtonItem = add;
    
}
- (void)pushAlert:(NSString *) message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:nil];

    header.textLabel.text = self.weatherCards.cardLists[section];
    header.textLabel.textColor = UIColor.systemBackgroundColor;
    header.textLabel.font = [UIFont systemFontOfSize:16];

    return header;
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
