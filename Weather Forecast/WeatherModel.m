//
//  WeatherModel.m
//  Weather Forecast
//
//  Created by lifany on 2026/7/15.
//
#import "WeatherModel.h"
@implementation HourWeather
- (instancetype)initWithHour:(NSString *)hour temperature:(CGFloat)hour_temp icon:(NSString *)icon code:(NSInteger)code{
    self = [super init];
    if (self) {
        self.hour = hour;
        self.hour_temp = hour_temp;
        self.hour_temp_icon = icon;
        self.code = code;
    }
    return self;
}
@end

@implementation DateWeather
- (instancetype)initWithDate:(NSString *)date max_temp:(CGFloat)max_temp min_temp:(CGFloat)min_temp icon:(NSString *)icon code:(NSInteger)code{
    self = [super init];
    if (self) {
        self.date = date;
        self.max_temp = max_temp;
        self.min_temp = min_temp;
        self.day_temp_icon = icon;
        self.code = code;
    }
    return self;
}
@end

@implementation CityWeather
- (instancetype) initWithData:(NSDictionary *) data {
    self = [super init];
    if (self) {
        [self setupWeatherModel:data];
    }
    return self;
}
- (void)setupWeatherModel:(NSDictionary *) data {
    NSDictionary *location = data[@"location"];
    self.city = [location[@"name"] isKindOfClass:[NSString class]] ? location[@"name"] : @"未知城市";
    self.country = [location[@"country"] isKindOfClass:[NSString class]] ? location[@"country"] : nil;
    
    NSDictionary *current = data[@"current"];
    self.temperature = [current[@"temp_c"] doubleValue];
    self.feelsLikeTemp = [current[@"feelslike_c"] doubleValue];
    self.windSpeed = [current[@"wind_mph"] doubleValue];
    self.precipitation = [current[@"precip_mm"] doubleValue];
    self.humidity = [current[@"humidity"] integerValue];
    CGFloat uv_num = [current[@"uv"] doubleValue];
    self.uv = [NSString stringWithFormat:@"%.0f", uv_num];
    self.co = [current[@"air_quality"][@"co"] doubleValue];
    self.o3 = [current[@"air_quality"][@"o3"] doubleValue];
    self.pm10 = [current[@"air_quality"][@"pm10"] doubleValue];
    self.US_EPA = [current[@"air_quality"][@"us-epa-index"] integerValue];
    self.weather = [current[@"condition"][@"text"] isKindOfClass:[NSString class]] ? current[@"condition"][@"text"] : nil;
    self.windDegree = [current[@"wind_dir"] isKindOfClass:[NSString class]] ? current[@"wind_dir"] : nil;
    NSInteger codeIcon = [current[@"condition"][@"code"] integerValue];
    self.weatherCode = codeIcon;
    NSString *image;
    self.weatherIcon = [self weatherIconWithCode:codeIcon image:&image];
    self.weatherBackImage = image;
    
    NSArray *forecastday = data[@"forecast"][@"forecastday"];
    NSDictionary *today = forecastday[0][@"day"];
    self.max_temperature = [today[@"maxtemp_c"] doubleValue];
    self.min_temperature = [today[@"mintemp_c"] doubleValue];
    NSDictionary *astro = forecastday[0][@"astro"];
    self.sunrise = [astro[@"sunrise"] isKindOfClass:[NSString class]] ? astro[@"sunrise"] : nil;
    self.sunset = [astro[@"sunset"] isKindOfClass:[NSString class]] ? astro[@"sunset"] : nil;
    self.moonrise = [astro[@"moonrise"] isKindOfClass:[NSString class]] ? astro[@"moonrise"] : nil;
    self.moonset = [astro[@"moonset"] isKindOfClass:[NSString class]] ? astro[@"moonset"] : nil;
    self.moon_phase = [astro[@"moon_phase"] isKindOfClass:[NSString class]] ? astro[@"moon_phase"] : nil;
    
    NSArray *hours = forecastday[0][@"hour"];
    NSMutableArray *tempHour = [NSMutableArray array];
    for (NSInteger i = 0; i < 24; i++) {
        NSString *timeStr = [NSString stringWithFormat:@"%02ld:00", (long)i];
        CGFloat hourTemp = [hours[i][@"temp_c"] doubleValue];
        NSInteger hourTempIconCode = [hours[i][@"condition"][@"code"] integerValue];
        NSString *hourTempIcon = [self weatherIconWithCode:hourTempIconCode image:nil];
        HourWeather *hourWeather = [[HourWeather alloc] initWithHour:timeStr temperature:hourTemp icon:hourTempIcon code:hourTempIconCode];
        [tempHour addObject:hourWeather];
    }
    self.todayHourWeather = tempHour;
    
    NSMutableArray *tempDate = [NSMutableArray array];
    for (NSDictionary *data in forecastday) {
        NSString *date = data[@"date"];
        CGFloat max_temp = [data[@"day"][@"maxtemp_c"] doubleValue];
        CGFloat min_temp = [data[@"day"][@"mintemp_c"] doubleValue];
        NSInteger tempIconCode = [data[@"day"][@"condition"][@"code"] integerValue];
        NSString *tempIcon = [self weatherIconWithCode:tempIconCode image:nil];
        DateWeather *dataWeather = [[DateWeather alloc] initWithDate:date max_temp:max_temp min_temp:min_temp icon:tempIcon code:tempIconCode];
        [tempDate addObject:dataWeather];
    }
    self.weekWeather = tempDate;
    if (uv_num >=0 && uv_num <= 2) {
        self.uv_grade = @"最弱";
    } else if (uv_num == 3 || uv_num == 4) {
        self.uv_grade = @"弱";
    } else if (uv_num == 5 || uv_num == 6) {
        self.uv_grade = @"中等";
    } else if (uv_num == 7 || uv_num == 8 || uv_num == 9) {
        self.uv_grade = @"强";
    } else {
        self.uv_grade = @"很强";
    }
}
- (NSString *)weatherIconWithCode:(NSInteger) code image:(NSString **) image{
    NSString *weatherIcon;
    switch (code) {
        case 1000:
            weatherIcon = @"sun.max.fill";
            if (image) {
                *image = @"sunny";
            }
            break;
        case 1003:
        case 1006:
            weatherIcon = @"cloud.sun.fill"; // 多云
            if (image) {
                *image = @"cloud";
            }
            break;
        case 1009:
            weatherIcon = @"cloud.fill"; // 阴
            if (image) {
                *image = @"cloudy";
            }
            break;
        case 1012:
        case 1039:
        case 1042:
        case 1030:
        case 1033:
        case 1036:
            weatherIcon = @"cloud.fog.fill"; // 雾霾
            if (image) {
                *image = @"fog";
            }
            break;
        case 1015:
            weatherIcon = @"smoke.fill"; // 尘雾
            if (image) {
                *image = @"smoke";
            }
            break;
        case 1018:
        case 1021:
        case 1024:
        case 1027:
        case 1045:
        case 1048:
            weatherIcon = @"cloud.fog.fill"; // 沙尘暴
            if (image) {
                *image = @"heavyfog";
            }
            break;
        case 1063:
        case 1072:
        case 1150:
        case 1153:
        case 1180:
        case 1183:
        case 1198:
        case 1240:
            weatherIcon = @"cloud.drizzle.fill"; // 小雨
            if (image) {
                *image = @"rainlittle";
            }
            break;
        case 1168:
        case 1186:
        case 1189:
            weatherIcon = @"cloud.rain.fill"; // 中雨
            if (image) {
                *image = @"rain";
            }
            break;
        case 1171:
        case 1192:
        case 1195:
        case 1243:
        case 1201:
        case 1246:
            weatherIcon = @"cloud.heavyrain.fill"; // 大雨
            if (image) {
                *image = @"rain";
            }
            break;
        case 1066:
        case 1210:
        case 1213:
        case 1255:
        case 1216:
        case 1219:
        case 1237:
        case 1258:
        case 1222:
        case 1225:
            weatherIcon = @"cloud.snow.fill"; // 雪
            if (image) {
                *image = @"snow";
            }
            break;
        case 1069:
        case 1204:
        case 1207:
        case 1249:
        case 1252:
            weatherIcon = @"cloud.sleet.fill"; // 雨夹雪
            if (image) {
                *image = @"snow";
            }
            break;
        case 1087:
            weatherIcon = @"cloud.bolt.fill"; // 雷暴
            if (image) {
                *image = @"bolt";
            }
            break;
        case 1114:
        case 1117:
        case 1279:
        case 1282:
            weatherIcon = @"wind.snow"; // 吹雪
            if (image) {
                *image = @"snow";
            }
            break;
        case 1147:
        case 1135:
            weatherIcon = @"smoke.fill"; // 大雾
            if (image) {
                *image = @"fog";
            }
            break;
        case 1261:
        case 1264:
            weatherIcon = @"cloud.hail.fill"; // 冰雹
            if (image) {
                *image = @"hail";
            }
            break;
        case 1273:
        case 1276:
            weatherIcon = @"cloud.bolt.rain.fill"; // 雷雨
            if (image) {
                *image = @"boltRain";
            }
            break;
        default:
            break;
    }
    return weatherIcon;
}
@end
@implementation WeatherCards
+ (instancetype)sharedInstance {
    static WeatherCards *cards = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cards = [[WeatherCards alloc] init];
        cards.cardLists = @[
            @"小时预报", @"多日预报", @"空气质量", @"", @"日落", @"月相"
        ];
    });
    return cards;
}
@end
@implementation SquareCards
+ (instancetype)sharedInstance {
    static SquareCards *cards = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cards = [[SquareCards alloc] init];
        cards.cardLists = @[
            @"紫外线", @"体感温度", @"湿度", @"风"
        ];
    });
    return cards;
}
@end

@implementation WeatherModel
+ (instancetype)sharedInstance {
    static WeatherModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[WeatherModel alloc] init];
        model.citys = [NSMutableArray array];
    });
    return model;
}

@end
