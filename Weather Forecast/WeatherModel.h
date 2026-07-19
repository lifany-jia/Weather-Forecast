//
//  WeatherModel.h
//  Weather Forecast
//
//  Created by lifany on 2026/7/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface HourWeather : NSObject
@property (nonatomic, copy) NSString *hour;
@property (nonatomic, assign) CGFloat hour_temp;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *hour_temp_icon;
- (instancetype) initWithHour:(NSString *) hour temperature:(CGFloat) hour_temp icon:(NSString *) icon code:(NSInteger) code;
@end

@interface DateWeather : NSObject
@property (nonatomic, copy) NSString *date;
@property (nonatomic, assign) CGFloat max_temp;
@property (nonatomic, assign) CGFloat min_temp;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *day_temp_icon;
- (instancetype) initWithDate:(NSString *) date max_temp:(CGFloat) max_temp min_temp:(CGFloat) min_temp icon:(NSString *)icon code:(NSInteger) code;
@end

@interface CityWeather : NSObject
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
@property (nonatomic, strong) NSArray<HourWeather *> *todayHourWeather; // time，temp_c，condition.icon
@property (nonatomic, strong) NSArray<DateWeather *> *weekWeather; // date，maxtemp_c, mintemp_c，condition.icon
- (instancetype) initWithData:(NSDictionary *) data;
@end
@interface WeatherCards : NSObject
@property (nonatomic, copy) NSArray<NSString *> *cardLists;
+ (instancetype) sharedInstance;
@end
@interface SquareCards : NSObject
@property (nonatomic, copy) NSArray<NSString *> *cardLists;
+ (instancetype) sharedInstance;
@end
@interface WeatherModel : NSObject
@property (nonatomic, strong, readonly) NSMutableArray<CityWeather *> *citys;
+ (instancetype) sharedInstance;
- (void)addCity:(CityWeather *) city;
- (void)removeCity:(NSInteger) index;
@end

NS_ASSUME_NONNULL_END
