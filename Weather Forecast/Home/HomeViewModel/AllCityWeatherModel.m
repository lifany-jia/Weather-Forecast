//
//  AllCityWeatherModel.m
//  Weather Forecast
//
//  Created by lifany on 2026/7/20.
//

#import "AllCityWeatherModel.h"
@interface AllCityWeatherModel ()
@property (nonatomic, strong) NSMutableArray<CityWeatherModel *> *citys;
@end
@implementation AllCityWeatherModel
+ (instancetype)sharedInstance {
    static AllCityWeatherModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[AllCityWeatherModel alloc] init];
        model.citys = [NSMutableArray array];
    });
    return model;
}
- (void)addCity:(CityWeatherModel *)city {
    NSLog(@"addCity");
    [self.citys addObject:city];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:KCityArrayKey];
    // 第一次保存时 array 为 nil，需要初始化为空数组
    // 不然以后每次添加都是对nil发消息就什么都没有！！
    NSMutableArray *mutableArray = array ? [array mutableCopy] : [NSMutableArray array];
    [mutableArray addObject:city.city];
    [[NSUserDefaults standardUserDefaults] setObject:mutableArray forKey:KCityArrayKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)removeCityWithData:(CityWeatherModel *)city {
    [self.citys removeObject:city];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:KCityArrayKey];
    NSMutableArray *mutableArray = array ? [array mutableCopy] : [NSMutableArray array];
    [mutableArray removeObject:city.city];
    [[NSUserDefaults standardUserDefaults] setObject:mutableArray forKey:KCityArrayKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)removeCity:(NSInteger)index {
    NSLog(@"removw");
    [self.citys removeObjectAtIndex:index];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:KCityArrayKey];
    NSMutableArray *mutableArray = array ? [array mutableCopy] : [NSMutableArray array];
    if (index < mutableArray.count) {
        [mutableArray removeObjectAtIndex:index];
    }
    [[NSUserDefaults standardUserDefaults] setObject:mutableArray forKey:KCityArrayKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSInteger)isCityInModel:(NSString *) cityName {
    for (CityWeatherModel *model in self.citys) {
        if ([model.city isEqualToString:cityName]) {
            return 0;
        }
    }
    return 1;
}
@end
