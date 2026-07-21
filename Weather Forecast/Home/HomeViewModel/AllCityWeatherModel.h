//
//  AllCityWeatherModel.h
//  Weather Forecast
//
//  Created by lifany on 2026/7/20.
//

#import <Foundation/Foundation.h>
#import "CityWeatherModel.h"
NS_ASSUME_NONNULL_BEGIN
static NSString *const KCityArrayKey = @"CityArrayKey";
@interface AllCityWeatherModel : NSObject
@property (nonatomic, strong, readonly) NSMutableArray<CityWeatherModel *> *citys;
+ (instancetype) sharedInstance;
- (NSInteger)addCity:(CityWeatherModel *) city;
- (void)removeCity:(NSInteger) index;
@end

NS_ASSUME_NONNULL_END
