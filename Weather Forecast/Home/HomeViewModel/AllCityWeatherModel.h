//
//  AllCityWeatherModel.h
//  Weather Forecast
//
//  Created by lifany on 2026/7/20.
//

#import <Foundation/Foundation.h>
#import "CityWeatherModel.h"
NS_ASSUME_NONNULL_BEGIN
/// 持久化存储key字符串
static NSString *const KCityArrayKey = @"CityArrayKey";
@interface AllCityWeatherModel : NSObject
@property (nonatomic, strong, readonly) NSMutableArray<CityWeatherModel *> *citys;
+ (instancetype) sharedInstance;
- (void)addCity:(CityWeatherModel *) city;
- (void)removeCity:(NSInteger) index;
- (void)removeCityWithData:(CityWeatherModel *) city;
- (NSInteger)isCityInModel:(NSString *) cityName;
@end

NS_ASSUME_NONNULL_END
