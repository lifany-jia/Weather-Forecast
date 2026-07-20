//
//  SquareCardCell.m
//  Weather Forecast
//
//  Created by lifany on 2026/7/18.
//

#import "SquareCardCell.h"
#import "SquareCollectionCell.h"
#import "SquareCardsModel.h"
#import <math.h>
#import <Masonry/Masonry.h>
@interface SquareCardCell () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) CityWeatherModel *data;
@property (nonatomic, strong) SquareCardsModel *cards;
@end
@implementation SquareCardCell

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
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.cards = [SquareCardsModel sharedInstance];
        [self setupCell];
    }
    return self;
}
- (void)setupCell {
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.minimumLineSpacing = 15;
    self.layout.minimumInteritemSpacing = 15;
    self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.layout.itemSize = CGSizeMake(175, 175);
    self.layout.sectionHeadersPinToVisibleBounds = YES;
    self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    self.collection.backgroundColor = [UIColor clearColor];
    self.collection.delegate = self;
    self.collection.dataSource = self;
    [self.collection registerClass:[SquareCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    [self.contentView addSubview:self.collection];
    [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.contentView);
        make.height.mas_equalTo(368);
    }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cards.cardLists.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SquareCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.item == 0) {
        [cell updateWithTitle:self.cards.cardLists[indexPath.item] content:self.data.uv supplement:self.data.uv_grade image:@"rainbow" big:50];
    } else if (indexPath.item == 1) {
        NSString *content = [NSString stringWithFormat:@"%.0f°", self.data.feelsLikeTemp];
        NSString *supplement = [NSString stringWithFormat:@"与实际温度相差%.0f°", fabs(self.data.feelsLikeTemp - self.data.temperature)];
        [cell updateWithTitle:self.cards.cardLists[indexPath.item] content:content supplement:supplement image:@"thermometer.low" big:30];
    } else if (indexPath.item == 2) {
        NSString *content = [NSString stringWithFormat:@"%ld%%", self.data.humidity];
        NSString *supplement = [NSString stringWithFormat:@"今日降水量%.0f°", self.data.precipitation];
        [cell updateWithTitle:self.cards.cardLists[indexPath.item] content:content supplement:supplement image:@"humidity" big:45];
    } else if (indexPath.item == 3) {
        NSString *content = [NSString stringWithFormat:@"%.0fkm/h", self.data.windSpeed];
        NSString *supplement = [NSString stringWithFormat:@"风向：%@°", self.data.windDegree];
        [cell updateWithTitle:self.cards.cardLists[indexPath.item] content:content supplement:supplement image:@"wind" big:45];
    }
    return cell;
}

- (void)updateWithData:(CityWeatherModel *)data {
    self.data = data;
    [self.collection reloadData];
}
@end
