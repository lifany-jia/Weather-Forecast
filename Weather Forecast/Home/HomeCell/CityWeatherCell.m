//
//  CityWeatherCell.m
//  Weather Forecast
//
//  Created by lifany on 2026/7/15.
//

#import "CityWeatherCell.h"
@interface CityWeatherCell ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *cityName;
@property (nonatomic, strong) UILabel *weather;
@property (nonatomic, strong) UILabel *temperature;
@property (nonatomic, strong) UILabel *maxmin_temp;
@property (nonatomic, strong) UIImageView *backImage;
@end
@implementation CityWeatherCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupCell];
    }
    return self;
}
- (void)setupCell {
    // 背景容器——圆角设在这里，编辑模式下不受 cell 缩进影响
    self.backView = [[UIView alloc] init];
    self.backView.layer.cornerRadius = 20;
    self.backView.layer.masksToBounds = YES;
    self.backView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    self.backImage = [[UIImageView alloc] init];
    self.backImage.clipsToBounds = YES;
    self.backImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.backView addSubview:self.backImage];
    [self.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backView);
    }];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.cityName = [[UILabel alloc] init];
    self.cityName.text = @"未知位置";
    self.cityName.textColor = [UIColor systemBackgroundColor];
    self.cityName.font = [UIFont boldSystemFontOfSize:27];
    [self.backView addSubview:self.cityName];
    [self.cityName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(17);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    self.weather = [[UILabel alloc] init];
    self.weather.text = @"--";
    self.weather.textColor = [UIColor systemGray6Color];
    self.weather.font = [UIFont boldSystemFontOfSize:17];
    [self.backView addSubview:self.weather];
    [self.weather mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cityName.mas_bottom).offset(30);
        make.left.equalTo(self.cityName).offset(3);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    self.temperature = [[UILabel alloc] init];
    self.temperature.text = @"_°";
    self.temperature.textColor = [UIColor systemBackgroundColor];
    self.temperature.font = [UIFont systemFontOfSize:43];
    [self.backView addSubview:self.temperature];
    [self.temperature mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cityName);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    self.maxmin_temp = [[UILabel alloc] init];
    self.maxmin_temp.text = @"_° / _°";
    self.maxmin_temp.textColor = [UIColor systemBackgroundColor];
    self.maxmin_temp.font = [UIFont systemFontOfSize:20];
    [self.backView addSubview:self.maxmin_temp];
    [self.maxmin_temp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.weather);
        make.right.equalTo(self.contentView).offset(-15);
    }];
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

@end
