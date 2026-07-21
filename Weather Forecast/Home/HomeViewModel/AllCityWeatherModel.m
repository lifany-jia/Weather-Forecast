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
- (NSInteger)addCity:(CityWeatherModel *)city {
    for (CityWeatherModel *temp in self.citys) {
        if ([city.city isEqualToString:temp.city]) {
            return 0;
        }
    }
    
    NSLog(@"addCity");
    [self.citys addObject:city];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:KCityArrayKey];
    // 第一次保存时 array 为 nil，需要初始化为空数组
    // 不然以后每次添加都是对nil发消息就什么都没有！！
    NSMutableArray *mutableArray = array ? [array mutableCopy] : [NSMutableArray array];
    [mutableArray addObject:city.city];
    [[NSUserDefaults standardUserDefaults] setObject:mutableArray forKey:KCityArrayKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return 1;
}
- (void)removeCity:(NSInteger)index {
    [self.citys removeObjectAtIndex:index];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:KCityArrayKey];
    NSMutableArray *mutableArray = array ? [array mutableCopy] : [NSMutableArray array];
    if (index < mutableArray.count) {
        [mutableArray removeObjectAtIndex:index];
    }
    [[NSUserDefaults standardUserDefaults] setObject:mutableArray forKey:KCityArrayKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
