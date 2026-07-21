//
//  PageViewController.h
//  Weather Forecast
//
//  Created by lifany on 2026/7/21.
//

#import <UIKit/UIKit.h>
#import "AllCityWeatherModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PageViewController : UIPageViewController
- (instancetype)initWithData:(AllCityWeatherModel *) data index:(NSInteger) index;
@end

NS_ASSUME_NONNULL_END
