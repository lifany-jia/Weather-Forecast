//
//  SquareCardsModel.m
//  Weather Forecast
//
//  Created by lifany on 2026/7/20.
//

#import "SquareCardsModel.h"

@implementation SquareCardsModel
+ (instancetype)sharedInstance {
    static SquareCardsModel *cards = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cards = [[SquareCardsModel alloc] init];
        cards.cardLists = @[
            @"紫外线", @"体感温度", @"湿度", @"风"
        ];
    });
    return cards;
}
@end
