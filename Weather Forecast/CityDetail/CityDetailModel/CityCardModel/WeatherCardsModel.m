//
//  WeatherCardsModel.m
//  Weather Forecast
//
//  Created by lifany on 2026/7/20.
//

#import "WeatherCardsModel.h"

@implementation WeatherCardsModel
+ (instancetype)sharedInstance {
    static WeatherCardsModel *cards = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cards = [[WeatherCardsModel alloc] init];
        cards.cardLists = @[
            @"小时预报", @"多日预报", @"空气质量", @"", @"日落", @"月相"
        ];
    });
    return cards;
}
@end
