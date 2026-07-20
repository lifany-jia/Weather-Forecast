//
//  SquareCollectionCell.m
//  Weather Forecast
//
//  Created by lifany on 2026/7/18.
//

#import "SquareCollectionCell.h"
#import <Masonry/Masonry.h>
@interface SquareCollectionCell ()
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *supplement;
@property (nonatomic, strong) UIImageView *image;
@end
@implementation SquareCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.cornerRadius = 20;
        self.contentView.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupBlurBackground];
        [self setupCell];
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
- (void)setupCell {
    self.title = [[UILabel alloc] init];
    self.title.textColor = [UIColor systemGray6Color];
    self.title.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(15);
    }];
    
    self.content = [[UILabel alloc] init];
    self.content.textColor = [UIColor systemBackgroundColor];
    self.content.font = [UIFont boldSystemFontOfSize:20];
    [self.contentView addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title);
            make.top.equalTo(self.title.mas_bottom).offset(10);
    }];
    self.supplement = [[UILabel alloc] init];
    self.supplement.textColor = [UIColor systemGray6Color];
    self.supplement.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.supplement];
    [self.supplement mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
            make.left.equalTo(self.title);
    }];
    self.image = [[UIImageView alloc] init];
    self.image.contentMode = UIViewContentModeScaleAspectFill;
    self.image.tintColor = [UIColor whiteColor];
    [self.contentView addSubview:self.image];
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).offset(7);
            make.right.equalTo(self.contentView).offset(-30);
    }];
}
- (void)updateWithTitle:(NSString *)title content:(NSString *)content supplement:(NSString *)supplement image:(NSString *)image big:(NSInteger)big{
    self.title.text = title;
    self.content.text = content;
    self.supplement.text = supplement;
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationPreferringMulticolor];
    UIImage *ima = [UIImage systemImageNamed:image withConfiguration:config];
    self.image.image = ima;
    [self.image mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(big);
    }];
}
@end
