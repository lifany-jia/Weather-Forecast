//
//  DateWeatherModel.h
//  Weather Forecast
//
//  Created by lifany on 2026/7/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateWeatherModel : NSObject
@property (nonatomic, copy) NSString *date;
@property (nonatomic, assign) CGFloat max_temp;
@property (nonatomic, assign) CGFloat min_temp;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *day_temp_icon;
- (instancetype) initWithDate:(NSString *) date max_temp:(CGFloat) max_temp min_temp:(CGFloat) min_temp icon:(NSString *)icon code:(NSInteger) code;
@end

NS_ASSUME_NONNULL_END
