//
//  HourCardCell.m
//  Weather Forecast
//
//  Created by lifany on 2026/7/17.
//

#import "HourCardCell.h"
#import "HourWeatherCollectionCell.h"
#import "WeatherModel.h"
#import <Masonry/Masonry.h>
@interface HourCardCell () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UILabel *title;
@end
@implementation HourCardCell

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
        self.data = [NSArray array];
        self.contentView.layer.cornerRadius = 20;
        self.contentView.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupBlurBackground];
        [self setupCollection];
    }
    return self;
}
- (void)setupBlurBackground {
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterialDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
    blurView.userInteractionEnabled = NO;
    [self.contentView insertSubview:blurView atIndex:0];
    [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}
- (void)setupCollection {
    self.title = [[UILabel alloc] init];
    self.title.text = @"气温(°C)";
    self.title.textColor = [UIColor systemBackgroundColor];
    self.title.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(13);
            make.left.equalTo(self.contentView).offset(20);
    }];
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.minimumInteritemSpacing = 5;
    self.layout.headerReferenceSize = CGSizeZero;
    self.layout.footerReferenceSize = CGSizeZero;
    self.layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
    self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    self.collection.dataSource = self;
    self.collection.delegate = self;
    self.collection.layer.cornerRadius = 18;
    self.collection.backgroundColor = [UIColor clearColor];
    self.collection.showsHorizontalScrollIndicator = NO;
    [self.collection registerClass:[HourWeatherCardCell class] forCellWithReuseIdentifier:@"cell"];
    [self.contentView addSubview:self.collection];
    [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.mas_bottom);
            make.bottom.equalTo(self.contentView).offset(-10);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.mas_equalTo(120);
    }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HourWeatherCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell updateWithData:self.data[indexPath.item]];
    return cell;
}
- (void)updateWithData:(NSArray *)data {
    self.data = data;
    [self.collection reloadData];
}
@end
