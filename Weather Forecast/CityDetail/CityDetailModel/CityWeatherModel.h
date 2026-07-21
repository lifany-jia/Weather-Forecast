//
//  CityWeatherModel.h
//  Weather Forecast
//
//  Created by lifany on 2026/7/20.
//

#import <Foundation/Foundation.h>
#import "DateWeatherModel.h"
#import "HourWeatherModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CityWeatherModel : NSObject
@property (nonatomic, copy) NSString *city;
@property (nonatomic, assign) CGFloat temperature; //temp_c
@property (nonatomic, assign) CGFloat max_temperature; //maxtemp_c
@property (nonatomic, assign) CGFloat min_temperature; //mintemp_c
@property (nonatomic, assign) CGFloat feelsLikeTemp; //feelslike_c
@property (nonatomic, assign) CGFloat windSpeed; //wind_mph  (Wind speed in miles per hour)
@property (nonatomic, assign) CGFloat precipitation; //precip_mm  (Precipitation amount in millimeters)
@property (nonatomic, assign) CGFloat co;         //current.air_quality.co
@property (nonatomic, assign) CGFloat o3;         //current.air_quality.c3
@property (nonatomic, assign) CGFloat pm10;         //current.air_quality.pm10
@property (nonatomic, assign) NSInteger humidity; //humidity
@property (nonatomic, assign) NSInteger US_EPA;
@property (nonatomic, assign) NSInteger weatherCode;
@property (nonatomic, copy) NSString *uv;         //uv
@property (nonatomic, copy) NSString *uv_grade;
@property (nonatomic, copy) NSString *windDegree; //wind_dir
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *weather;
@property (nonatomic, copy) NSString *weatherIcon;
@property (nonatomic, copy) NSString *weatherBackImage;
@property (nonatomic, copy) NSString *sunrise; //sunrise
@property (nonatomic, copy) NSString *sunset; // sunset
@property (nonatomic, copy) NSString *moonrise; // moonrise
@property (nonatomic, copy) NSString *moonset; // moonset
@property (nonatomic, copy) NSString *moon_phase; // moon_phase
@property (nonatomic, assign) NSInteger currentTime; // moon_phase
@property (nonatomic, strong) NSArray<HourWeatherModel *> *todayHourWeather; // time，temp_c，condition.icon
@property (nonatomic, strong) NSArray<HourWeatherModel *> *yesterdayHourWeather; // time，temp_c，condition.icon
@property (nonatomic, strong) NSArray<HourWeatherModel *> *currNextHourWeather; // time，temp_c，condition.icon
@property (nonatomic, strong) NSArray<DateWeatherModel *> *weekWeather; // date，maxtemp_c, mintemp_c，condition.icon
- (instancetype) initWithData:(NSDictionary *) data;
@end

NS_ASSUME_NONNULL_END
