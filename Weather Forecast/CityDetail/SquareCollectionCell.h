//
//  SquareCollectionCell.h
//  Weather Forecast
//
//  Created by lifany on 2026/7/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SquareCollectionCell : UICollectionViewCell
- (void)updateWithTitle:(NSString *) title content:(NSString *) content supplement:(NSString *) supplement image:(NSString *) image big:(NSInteger) big;
@end

NS_ASSUME_NONNULL_END
