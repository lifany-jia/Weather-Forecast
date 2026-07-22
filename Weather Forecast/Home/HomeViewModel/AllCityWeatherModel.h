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
/// 添加城市
///
/// 添加到主页城市cell
/// - Returns:
/// 0：该城市已经存在
/// 1：城市添加成功
/// - Throws:返回nil
- (NSInteger)addCity:(CityWeatherModel *) city;
- (void)removeCity:(NSInteger) index;
@end

NS_ASSUME_NONNULL_END
