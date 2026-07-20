//
//  WeatherCardCell.m
//  Weather Forecast
//
//  Created by lifany on 2026/7/17.
//

#import "WeatherCardCell.h"
#import <Masonry/Masonry.h>
@interface WeatherCardCell ()
//@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *up;
@property (nonatomic, strong) UILabel *up_num;
@property (nonatomic, strong) UILabel *down;
@property (nonatomic, strong) UILabel *down_num;
@property (nonatomic, strong) UILabel *aqi;
@property (nonatomic, strong) UILabel *aqi_num;
@property (nonatomic, strong) UILabel *sunrise;
@property (nonatomic, strong) UILabel *sunset;
@property (nonatomic, strong) UILabel *sunriseTime;
@property (nonatomic, strong) UILabel *sunsetTime;
@end
@implementation WeatherCardCell

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
        self.contentView.layer.cornerRadius = 20;
        self.contentView.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupBlurBackground];
        if ([reuseIdentifier isEqualToString:AirQualityCellIdentifier]) {
            [self setupAirQualityCard];
        } else if ([reuseIdentifier isEqualToString:SunCellIdentifier]) {
            [self setupSunCard];
        } else if ([reuseIdentifier isEqualToString:MoonCellIdentifier]) {
            [self setupMoonCard];
        }
    }
    return self;
}
- (void)setupBlurBackground {
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterialDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
    blurView.userInteractionEnabled = NO;
    blurView.alpha = 0.5;
    [self.contentView insertSubview:blurView atIndex:0];
    [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}
- (void)setupAirQualityCard {
    self.title = [[UILabel alloc] init];
    self.title.font = [UIFont boldSystemFontOfSize:30];
    self.title.textColor = [UIColor systemBackgroundColor];
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15);
            make.left.equalTo(self.contentView).offset(15);
    }];
    
    self.up = [[UILabel alloc] init];
    self.up.text = @"O₃";
    self.up.textColor = [UIColor systemGray4Color];
    [self.contentView addSubview:self.up];
    [self.up mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title);
            make.top.equalTo(self.title.mas_bottom).offset(45);
    }];
    
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [UIColor systemGray6Color];
    separator.layer.cornerRadius = 3;
    [self.contentView addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.up.mas_bottom).offset(5);
            make.left.equalTo(self.title);
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(190);
    }];
    
    self.down = [[UILabel alloc] init];
    self.down.text = @"PM₁₀";
    self.down.textColor = [UIColor systemGray4Color];
    [self.contentView addSubview:self.down];
    [self.down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title);
        make.top.equalTo(separator.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    self.up_num = [[UILabel alloc] init];
    self.up_num.textColor = [UIColor systemBackgroundColor];
    [self.contentView addSubview:self.up_num];
    [self.up_num mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(separator);
            make.centerY.equalTo(self.up);
    }];
    
    self.down_num = [[UILabel alloc] init];
    self.down_num.textColor = [UIColor systemBackgroundColor];
    [self.contentView addSubview:self.down_num];
    [self.down_num mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(separator);
            make.centerY.equalTo(self.down);
    }];
    
    self.aqi_num = [[UILabel alloc] init];
    self.aqi_num.font = [UIFont boldSystemFontOfSize:50];
    self.aqi_num.textColor = [UIColor systemBackgroundColor];
    [self.contentView addSubview:self.aqi_num];
    [self.aqi_num mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-60);
            make.centerY.equalTo(self.contentView).offset(-10);
    }];
    
    self.aqi = [[UILabel alloc] init];
    self.aqi.text = @"AQI";
    self.aqi.font = [UIFont systemFontOfSize:15];
    self.aqi.textColor = [UIColor systemBackgroundColor];
    [self.contentView addSubview:self.aqi];
    [self.aqi mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.aqi_num);
            make.top.equalTo(self.aqi_num.mas_bottom).offset(10);
    }];
}
- (void)updateWithAirData:(CityWeatherModel *)data {
    NSString *airQualityText;
    if (data.US_EPA > 0 && data.US_EPA <= 50) {
        airQualityText = @"优质";
    } else if (data.US_EPA > 50 && data.US_EPA <= 100) {
        airQualityText = @"良好";
    } else if (data.US_EPA > 100 && data.US_EPA <= 150) {
        airQualityText = @"轻度污染";
    } else if (data.US_EPA > 150 && data.US_EPA <= 200) {
        airQualityText = @"中度污染";
    } else if (data.US_EPA > 200 && data.US_EPA <= 300) {
        airQualityText = @"重度污染";
    } else if (data.US_EPA > 300 && data.US_EPA <= 500) {
        airQualityText = @"严重污染";
    }
    self.title.text = airQualityText;
    self.up_num.text = [NSString stringWithFormat:@"%.0f", data.o3];
    self.down_num.text = [NSString stringWithFormat:@"%.0f", data.pm10];
    self.aqi_num.text = [NSString stringWithFormat:@"%li", data.US_EPA];
}
- (void)setupSunCard {
    self.sunriseTime = [[UILabel alloc] init];
    self.sunriseTime.textColor = [UIColor systemBackgroundColor];
    self.sunriseTime.font = [UIFont boldSystemFontOfSize:20];
    [self.contentView addSubview:self.sunriseTime];
    [self.sunriseTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(20);
            make.left.equalTo(self.contentView).offset(20);
    }];
    self.sunrise = [[UILabel alloc] init];
    self.sunrise.textColor = [UIColor systemGray6Color];
    self.sunrise.font = [UIFont boldSystemFontOfSize:15];
    self.sunrise.text = @"日出";
    [self.contentView addSubview:self.sunrise];
    [self.sunrise mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.sunriseTime);
            make.left.equalTo(self.sunriseTime.mas_right).offset(5);
    }];
    self.sunsetTime = [[UILabel alloc] init];
    self.sunsetTime.textColor = [UIColor systemBackgroundColor];
    self.sunsetTime.font = [UIFont boldSystemFontOfSize:20];
    [self.contentView addSubview:self.sunsetTime];
    [self.sunsetTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sunriseTime.mas_bottom).offset(15);
            make.left.equalTo(self.sunriseTime);
    }];
    self.sunset = [[UILabel alloc] init];
    self.sunset.textColor = [UIColor systemGray6Color];
    self.sunset.font = [UIFont boldSystemFontOfSize:15];
    self.sunset.text = @"日落";
    [self.contentView addSubview:self.sunset];
    [self.sunset mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.sunsetTime);
            make.left.equalTo(self.sunrise);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    UIImage *sun = [UIImage systemImageNamed:@"sun.haze"];
    UIImageView *sunV = [[UIImageView alloc] initWithImage:sun];
    sunV.tintColor = [UIColor systemBackgroundColor];
    sunV.backgroundColor = [UIColor clearColor];
    sunV.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:sunV];
    [sunV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-40);
        make.width.mas_equalTo(60);
    }];
}
- (void)updateWithSunData:(CityWeatherModel *)data {
    self.sunriseTime.text = data.sunrise;
    self.sunsetTime.text = data.sunset;
}
- (void)setupMoonCard {
    self.title = [[UILabel alloc] init];
    self.title.font = [UIFont systemFontOfSize:25];
    self.title.textColor = [UIColor systemBackgroundColor];
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15);
            make.left.equalTo(self.contentView).offset(15);
    }];
    
    self.up = [[UILabel alloc] init];
    self.up.text = @"月出";
    self.up.font = [UIFont systemFontOfSize:16];
    self.up.textColor = [UIColor systemGray4Color];
    [self.contentView addSubview:self.up];
    [self.up mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title);
            make.top.equalTo(self.title.mas_bottom).offset(40);
    }];
    
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [UIColor systemGray6Color];
    separator.layer.cornerRadius = 3;
    [self.contentView addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.up.mas_bottom).offset(5);
            make.left.equalTo(self.title);
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(190);
    }];
    
    self.down = [[UILabel alloc] init];
    self.down.text = @"月落";
    self.down.font = [UIFont systemFontOfSize:16];
    self.down.textColor = [UIColor systemGray4Color];
    [self.contentView addSubview:self.down];
    [self.down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title);
        make.top.equalTo(separator.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    self.up_num = [[UILabel alloc] init];
    self.up_num.font = [UIFont systemFontOfSize:16];
    self.up_num.textColor = [UIColor systemBackgroundColor];
    [self.contentView addSubview:self.up_num];
    [self.up_num mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(separator);
            make.centerY.equalTo(self.up);
    }];
    
    self.down_num = [[UILabel alloc] init];
    self.down_num.font = [UIFont systemFontOfSize:16];
    self.down_num.textColor = [UIColor systemBackgroundColor];
    [self.contentView addSubview:self.down_num];
    [self.down_num mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(separator);
            make.centerY.equalTo(self.down);
    }];
    UIImage *moon = [UIImage systemImageNamed:@"moon.haze"];
    UIImageView *moonV = [[UIImageView alloc] initWithImage:moon];
    moonV.tintColor = [UIColor systemBackgroundColor];
    moonV.backgroundColor = [UIColor clearColor];
    moonV.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:moonV];
    [moonV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-30);
        make.width.mas_equalTo(70);
    }];
}
- (void)updateWithMoonData:(CityWeatherModel *)data {
    self.title.text = data.moon_phase;
    self.up_num.text = data.moonrise;
    self.down_num.text = data.moonset;
}
@end
