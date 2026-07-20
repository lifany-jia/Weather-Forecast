//
//  WeekWeatherTableViewCell.h
//  Weather Forecast
//
//  Created by lifany on 2026/7/18.
//

#import <UIKit/UIKit.h>
#import "DateWeatherModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WeekWeatherTableViewCell : UITableViewCell
- (void)updateWithData:(DateWeatherModel *) data;
@end

NS_ASSUME_NONNULL_END
