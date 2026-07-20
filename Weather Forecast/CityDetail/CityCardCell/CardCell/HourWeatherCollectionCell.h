//
//  HourWeatherCardCell.h
//  Weather Forecast
//
//  Created by lifany on 2026/7/17.
//

#import <UIKit/UIKit.h>
#import "HourWeatherModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HourWeatherCardCell : UICollectionViewCell
- (void)updateWithData:(HourWeatherModel *) data;
@end

NS_ASSUME_NONNULL_END
