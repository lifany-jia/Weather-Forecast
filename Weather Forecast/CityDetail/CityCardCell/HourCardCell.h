//
//  HourCardCell.h
//  Weather Forecast
//
//  Created by lifany on 2026/7/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const HourCellIdentifier = @"HourCell";
@interface HourCardCell : UITableViewCell
- (void)updateWithData:(NSArray *) data;
@end

NS_ASSUME_NONNULL_END
