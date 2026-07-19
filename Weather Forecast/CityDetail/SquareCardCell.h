//
//  SquareCardCell.h
//  Weather Forecast
//
//  Created by lifany on 2026/7/18.
//

#import <UIKit/UIKit.h>
#import "WeatherModel.h"
NS_ASSUME_NONNULL_BEGIN

static NSString *const SquareCellIdentifier = @"SquareCell";
@interface SquareCardCell : UITableViewCell
- (void)updateWithData:(CityWeather *) data;
@end

NS_ASSUME_NONNULL_END
