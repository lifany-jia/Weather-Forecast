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
    for (CityWeatherModel *temp in self.citys) {
        if ([city.city isEqualToString:temp.city]) {
            return;
        }
    }
    [self.citys addObject:city];
}
- (void)removeCity:(NSInteger)index {
    [self.citys removeObjectAtIndex:index];
}
@end
