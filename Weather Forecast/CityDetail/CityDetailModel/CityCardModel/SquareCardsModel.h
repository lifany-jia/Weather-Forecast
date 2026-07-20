//
//  SquareCardsModel.h
//  Weather Forecast
//
//  Created by lifany on 2026/7/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SquareCardsModel : NSObject
@property (nonatomic, copy) NSArray<NSString *> *cardLists;
+ (instancetype) sharedInstance;
@end

NS_ASSUME_NONNULL_END
