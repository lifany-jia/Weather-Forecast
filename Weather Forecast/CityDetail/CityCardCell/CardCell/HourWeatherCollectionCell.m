//
//  HourWeatherCardCell.m
//  Weather Forecast
//
//  Created by lifany on 2026/7/17.
//

#import "HourWeatherCollectionCell.h"
#import <Masonry/Masonry.h>
@interface HourWeatherCardCell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *temperature;
@property (nonatomic, strong) UILabel *date;
@end
@implementation HourWeatherCardCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCell];
    }
    return self;
}
- (void)setupCell {
    self.date = [[UILabel alloc] init];
    self.date.textColor = [UIColor systemBackgroundColor];
    self.date.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.date];
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
    }];
    
    self.icon = [[UIImageView alloc] init];
    self.icon.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.date.mas_bottom).offset(20);
            make.centerX.equalTo(self.contentView);
            make.width.height.mas_equalTo(30);
    }];
    
    self.temperature = [[UILabel alloc] init];
    self.temperature.textColor = [UIColor systemBackgroundColor];
    self.temperature.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.temperature];
    [self.temperature mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.icon.mas_bottom).offset(20);
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
}
- (void)updateWithData:(HourWeatherModel *)data {
    NSString *time = [NSString stringWithFormat:@"%02ld:00", data.hour];
    self.date.text = time;
    NSString *temp = [NSString stringWithFormat:@"%ld°", (long)data.hour_temp];
    self.temperature.text = temp;
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationPreferringMulticolor];
    UIImage *icon = [UIImage systemImageNamed:data.hour_temp_icon withConfiguration:config];
    self.icon.image = icon;
}
@end
