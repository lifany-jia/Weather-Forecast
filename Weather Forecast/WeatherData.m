//
//  WeatherDate.m
//  Weather Forecast
//
//  Created by lifany on 2026/7/15.
//

#import "WeatherData.h"
@interface WeatherData ()
@property (nonatomic, strong, nullable) NSURLSessionDataTask *citySearchTask;
@end
// 全局变量 字符串常量
static NSString *const WeatherDataErrorDomain = @"WeatherDataError";
static NSString *const CityDataErrorDomain = @"CityDataError";
@implementation WeatherData
+ (instancetype)sharedInstance {
    static WeatherData *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WeatherData alloc] init];
    });
    return instance;
}
- (void)fetchCityForecastWeatherData:(NSString *)city completion:(void (^)(NSDictionary *dictionary, NSError *error))completion {
   // 去掉字符串首尾指定字符，CharacterSet是字符集合
    NSString *currentCity = [city stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (currentCity.length == 0) {
        // domain：错误属于哪个系统或模块 code：这个模块中的具体错误编号 userInfo：错误的补充信息
        // NSLocalizedDescriptionKey是Foundation预先定义好的一个key，用来保存适合展示给用户或开发者看的错误说明
        // 读取的时候就是这样error.localizedDescription = error.userInfo[NSLocalizedDescriptionKey]
        // userInfo里也可以这样写@"requestType" : @"CitySearch"
        NSError *cityError = [NSError errorWithDomain:WeatherDataErrorDomain code:1000 userInfo:@{
            NSLocalizedDescriptionKey: @"城市名不能为空"
        }];
        completion(nil, cityError);
    }
    NSString *key = @"86ab17e2e6644c74a2d32502261507";
    NSString *lang = @"zh_cmn";
    NSString *alert = @"yes";
    NSString *aqi = @"yes";
    NSString *day = @"7";
    NSURLComponents *components = [NSURLComponents componentsWithString:@"http://api.weatherapi.com/v1/forecast.json "];
    components.queryItems = @[
        [NSURLQueryItem queryItemWithName:@"key" value:key],
        [NSURLQueryItem queryItemWithName:@"q" value:city],
        [NSURLQueryItem queryItemWithName:@"day" value:day],
        [NSURLQueryItem queryItemWithName:@"lang" value:lang],
        [NSURLQueryItem queryItemWithName:@"alerts" value:alert],
        [NSURLQueryItem queryItemWithName:@"aqi" value:aqi]
    ];
    NSURL *url = components.URL;
    if (!url) {
        NSError *urlError = [NSError errorWithDomain:WeatherDataErrorDomain code:1001 userInfo:@{
            NSLocalizedDescriptionKey : @"URL创建失败"
        }];
        completion(nil, urlError);
        return;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 15.0;
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
            return;
        }
        if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSError *responseError = [NSError errorWithDomain:WeatherDataErrorDomain code:1002 userInfo:@{
                NSLocalizedDescriptionKey : @"响应类型错误"
            }];
            completion(nil, responseError);
            return ;
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
            NSError *httpStatusError = [NSError errorWithDomain:WeatherDataErrorDomain code:httpResponse.statusCode userInfo:@{
                NSLocalizedDescriptionKey : @"HTTP状态码错误"
            }];
            completion(nil, httpStatusError);
            return;
        }
        if (!data || data.length == 0) {
            NSError *dataError = [NSError errorWithDomain:WeatherDataErrorDomain code:1003 userInfo:@{
                NSLocalizedDescriptionKey : @"服务器返回数据为空"
            }];
            completion(nil, dataError);
            return;
        }
        NSError *jsonError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            completion(nil, jsonError);
            return ;
        }
        if (![jsonObject isKindOfClass:[NSDictionary class]]) {
            NSError *typeError = [NSError errorWithDomain:WeatherDataErrorDomain code:1004 userInfo:@{
                NSLocalizedDescriptionKey : @"JSON 最外层不是字典"
            }];
            completion(nil, typeError);
            return;
        }
        NSDictionary *weatherData = (NSDictionary *)jsonObject;
        if (completion) {
            completion(weatherData, nil);
        }
    }];
    [task resume];
}
- (void)fetchAssociatedCityNameData:(NSString *)name completion:(void (^)(NSArray *cityName, NSError *error))completion {
    NSString *currentName = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (currentName.length == 0) {
        if (completion) {
            completion(@[], nil);
        }
        return;
    }
    // 就算上一个任务是nil也没问题，因为给nil发消息是合法的
    [self.citySearchTask cancel];
    self.citySearchTask = nil;
    NSString *key = @"86ab17e2e6644c74a2d32502261507";
    NSURLComponents *components = [NSURLComponents componentsWithString:@"http://api.weatherapi.com/v1/search.json"];
    components.queryItems = @[
        [NSURLQueryItem queryItemWithName:@"key" value:key],
        [NSURLQueryItem queryItemWithName:@"q" value:name]
    ];
    NSURL *url = components.URL;
    if (!url) {
        NSError *urlError = [NSError errorWithDomain:CityDataErrorDomain code:1001 userInfo:@{
            NSLocalizedDescriptionKey : @"URL创建失败"
        }];
        completion(nil, urlError);
        return;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 10.0;
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    // block内用到了self，避免循引用
    __weak typeof(self) weakSelf = self;
    self.citySearchTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 此时任务真正结束了，task没有用了
        // 如果在block外面，也就是resume之后，由于是异步，所以运行到resume后面任务其实还没有结束
        // 在还没有结束的时候就等于nil会导致引用丢失
        weakSelf.citySearchTask = nil;
        if (error) {
            // 当主动请求取消任务的时候不算错误
            // [self.citySearchTask cancel]取消任务后NSURLSession 通常仍会进入该任务的completionHandler同时error!=nil
            // error内容 Domain:NSURLErrorDomain，error.code == NSURLErrorCancelled
            // NSURLErrorCancelled 通常对应数值 -999
            if (error.code == NSURLErrorCancelled) {
                return;
            }
            completion(nil, error);
            return;
        }
        if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSError *responseError = [NSError errorWithDomain:CityDataErrorDomain code:1002 userInfo:@{
                NSLocalizedDescriptionKey : @"响应类型错误"
            }];
            completion(nil, responseError);
            return ;
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
            NSError *httpStatusError = [NSError errorWithDomain:CityDataErrorDomain code:httpResponse.statusCode userInfo:@{
                NSLocalizedDescriptionKey : @"HTTP状态码错误"
            }];
            completion(nil, httpStatusError);
        }
        if (!data || data.length == 0) {
            NSError *dataError = [NSError errorWithDomain:CityDataErrorDomain code:1003 userInfo:@{
                NSLocalizedDescriptionKey : @"服务器返回数据为空"
            }];
            completion(nil, dataError);
            return;
        }
        NSError *jsonError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            if (completion) {
                completion(nil, jsonError);
            }
            return;
        }
        if (![jsonObject isKindOfClass:[NSArray class]]) {
            NSError *typeError = [NSError errorWithDomain:CityDataErrorDomain code:1004 userInfo:@{
                NSLocalizedDescriptionKey : @"JSON最外层不是数组"
            }];
            completion(nil, typeError);
            return;
        }
        NSArray *cityList = (NSArray *)jsonObject;
        if (completion) {
            completion(cityList, nil);
        }
    }];
    [self.citySearchTask resume];
}
- (void)cancelCurrentCitySearch {
    [self.citySearchTask cancel];
    self.citySearchTask = nil;
}
@end
