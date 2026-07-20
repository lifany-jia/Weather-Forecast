//
//  HourWeatherModel.h
//  Weather Forecast
//
//  Created by lifany on 2026/7/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HourWeatherModel : NSObject
@property (nonatomic, copy) NSString *hour;
@property (nonatomic, assign) CGFloat hour_temp;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *hour_temp_icon;
- (instancetype) initWithHour:(NSString *) hour temperature:(CGFloat) hour_temp icon:(NSString *) icon code:(NSInteger) code;
@end

NS_ASSUME_NONNULL_END
