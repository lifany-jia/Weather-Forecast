//
//  WeekCardCell.m
//  Weather Forecast
//
//  Created by lifany on 2026/7/18.
//

#import "WeekCardCell.h"
#import "WeekWeatherTableViewCell.h"
#import <Masonry/Masonry.h>
@interface WeekCardCell () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray<DateWeatherModel *> * data;
@property (nonatomic, strong) UITableView *tableView;
@end
@implementation WeekCardCell

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
        self.data = [NSArray array];
        self.contentView.layer.cornerRadius = 20;
        self.contentView.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupBlurBackground];
        [self setupTableView];
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
- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.tableView registerClass:[WeekWeatherTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo(349);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeekWeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell updateWithData:self.data[indexPath.row]];
    return cell;
}
- (void)updateWithData:(NSArray<DateWeatherModel *> *)data {
    self.data = data;
    [self.tableView reloadData];
}
@end
