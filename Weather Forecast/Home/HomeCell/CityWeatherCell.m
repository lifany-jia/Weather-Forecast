//
//  CityWeatherCell.m
//  Weather Forecast
//
//  Created by lifany on 2026/7/15.
//

#import "CityWeatherCell.h"
@interface CityWeatherCell ()
@property (nonatomic, strong) UILabel *cityName;
@property (nonatomic, strong) UILabel *weather;
@property (nonatomic, strong) UILabel *temperature;
@property (nonatomic, strong) UILabel *maxmin_temp;
@property (nonatomic, strong) UIImageView *backImage;
@end
@implementation CityWeatherCell

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
        self.layer.cornerRadius = 20;
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupBackImage];
        [self setupCell];
    }
    return self;
}
- (void)setupCell {
    self.cityName = [[UILabel alloc] init];
    self.cityName.text = @"未知位置";
    self.cityName.textColor = [UIColor systemBackgroundColor];
    self.cityName.font = [UIFont boldSystemFontOfSize:27];
    [self.contentView addSubview:self.cityName];
    [self.cityName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(17);
            make.top.equalTo(self.contentView).offset(15);
    }];
    
    self.weather = [[UILabel alloc] init];
    self.weather.text = @"--";
    self.weather.textColor = [UIColor systemGray6Color];
    self.weather.font = [UIFont boldSystemFontOfSize:17];
    [self.contentView addSubview:self.weather];
    [self.weather mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cityName.mas_bottom).offset(30);
        make.left.equalTo(self.cityName).offset(3);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    self.temperature = [[UILabel alloc] init];
    self.temperature.text = @"_°";
    self.temperature.textColor = [UIColor systemBackgroundColor];
    self.temperature.font = [UIFont systemFontOfSize:43];
    [self.contentView addSubview:self.temperature];
    [self.temperature mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cityName);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    self.maxmin_temp = [[UILabel alloc] init];
    self.maxmin_temp.text = @"_° / _°";
    self.maxmin_temp.textColor = [UIColor systemBackgroundColor];
    self.maxmin_temp.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:self.maxmin_temp];
    [self.maxmin_temp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.weather);
        make.right.equalTo(self.contentView).offset(-15);
    }];
}
- (void)setupBackImage {
    self.backImage = [[UIImageView alloc] init];
    self.backImage.clipsToBounds = YES;
    self.backImage.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundView = self.backImage;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)updateWithData:(CityWeatherModel *)data {
    self.cityName.text = data.city;
    self.weather.text = data.weather;
    NSString *tempStr = [NSString stringWithFormat:@"%.0f°", data.temperature];
    self.temperature.text = tempStr;
    NSString *maxminStr = [NSString stringWithFormat:@"%.0f° / %.0f°", data.min_temperature, data.max_temperature];
    self.maxmin_temp.text = maxminStr;
    NSString *nameIma = [NSString stringWithFormat:@"%@2.0", data.weatherBackImage];
    UIImage *image = [UIImage imageNamed:nameIma];
    self.backImage.image = image;
}

// 重写该函数，解决tableView按住城市不松手进入highlighted 状态，背景图片会消失/变透明
//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
//    [super setHighlighted:highlighted animated:animated];
//    self.backgroundView.alpha = 1.0;
//    self.backgroundView.hidden = NO;
//}
@end
