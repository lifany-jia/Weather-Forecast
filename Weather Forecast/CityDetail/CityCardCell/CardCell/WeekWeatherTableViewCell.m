//
//  WeekWeatherTableViewCell.m
//  Weather Forecast
//
//  Created by lifany on 2026/7/18.
//

#import "WeekWeatherTableViewCell.h"
#import <Masonry/Masonry.h>
@interface WeekWeatherTableViewCell ()
@property (nonatomic, strong) UILabel *date;
@property (nonatomic, strong) UIImageView *weatherIcon;
@property (nonatomic, strong) UILabel *max_temp;
@property (nonatomic, strong) UILabel *min_temp;
@end
@implementation WeekWeatherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self setupCell];
    }
    return self;
}
- (void)setupCell {
    self.date = [[UILabel alloc] init];
    self.date.textColor = [UIColor systemBackgroundColor];
    self.date.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.date];
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15);
            make.bottom.equalTo(self.contentView).offset(-15);
            make.left.equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(95);
    }];
    self.weatherIcon = [[UIImageView alloc] init];
    self.weatherIcon.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.weatherIcon];
    [self.weatherIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.date);
            make.left.equalTo(self.date.mas_right).offset(20);
            make.height.width.mas_equalTo(20);
    }];
    
    self.max_temp = [[UILabel alloc] init];
    self.max_temp.textColor = [UIColor systemBackgroundColor];
    self.max_temp.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.max_temp];
    [self.max_temp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.date);
            make.right.equalTo(self.contentView).offset(-15);
        make.width.mas_equalTo(30);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor orangeColor];
    line.layer.cornerRadius = 3;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.date);
            make.right.equalTo(self.max_temp.mas_left).offset(-15);
            make.height.mas_equalTo(4);
            make.width.mas_equalTo(97);
    }];
    
    self.min_temp = [[UILabel alloc] init];
    self.min_temp.textColor = [UIColor systemGray6Color];
    self.min_temp.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.min_temp];
    [self.min_temp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.date);
            make.right.equalTo(line.mas_left).offset(-15);
    }];
}
- (void)updateWithData:(DateWeatherModel *)data {
    self.date.text = data.date;
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationPreferringMulticolor];
    UIImage *icon = [UIImage systemImageNamed:data.day_temp_icon withConfiguration:config];
    self.weatherIcon.image = icon;
    NSString *max_temp = [NSString stringWithFormat:@"%.0f°", data.max_temp];
    NSString *min_temp = [NSString stringWithFormat:@"%.0f°", data.min_temp];
    self.min_temp.text = min_temp;
    self.max_temp.text = max_temp;
}
@end
