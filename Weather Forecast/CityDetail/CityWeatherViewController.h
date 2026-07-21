//
//  CityWeatherViewController.h
//  Weather Forecast
//
//  Created by lifany on 2026/7/16.
//

#import <UIKit/UIKit.h>
#import "CityWeatherModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CityWeatherViewController : UIViewController
@property (nonatomic, assign) NSInteger pageIndex;
- (instancetype)initWithCityData:(CityWeatherModel *) cityData;
@end

NS_ASSUME_NONNULL_END
