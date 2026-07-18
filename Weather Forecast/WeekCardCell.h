//
//  WeekCardCell.h
//  Weather Forecast
//
//  Created by lifany on 2026/7/18.
//

#import <UIKit/UIKit.h>
#import "WeatherModel.h"
NS_ASSUME_NONNULL_BEGIN
static NSString *const WeekCellIdentifier = @"WeekCell";
@interface WeekCardCell : UITableViewCell
- (void)updateWithData:(NSArray<DateWeather *> *)data;
@end

NS_ASSUME_NONNULL_END
