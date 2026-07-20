//
//  WeatherDate.h
//  Weather Forecast
//
//  Created by lifany on 2026/7/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherData : NSObject
+ (instancetype)sharedInstance;
- (void)fetchCityForecastWeatherData:(NSString *) city completion:(void(^)(NSDictionary *dictionary, NSError *error)) completion;
- (void)fetchAssociatedCityNameData:(NSString *) name completion:(void(^)(NSArray *cityName, NSError *error)) completion;
- (void)cancelCurrentCitySearch;
@end

NS_ASSUME_NONNULL_END
