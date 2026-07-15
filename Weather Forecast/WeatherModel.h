//
//  WeatherModel.h
//  Weather Forecast
//
//  Created by lifany on 2026/7/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface CityWeather : NSObject
@property (nonatomic, copy) NSString *city;
@property (nonatomic, assign) CGFloat temperature;

@end
@interface WeatherModel : NSObject


@end

NS_ASSUME_NONNULL_END
