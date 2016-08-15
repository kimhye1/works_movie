//
//  WMEditVideoViewController.m
//  WorksMovie
//
//  Created by Naver on 2016. 8. 12..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMEditVideoViewController.h"
#import "WMVideoCollectionViewCell.h"
#import "WMVideoHelper.h"
#import "WMPlayAndStoreVideoViewController.h"
#import "WMPlayAndApplyFilterViewController.h"

@interface WMEditVideoViewController ()

@property (nonatomic, strong) WMVideoModelManager *modelManager;
@property (nonatomic, strong) WMVideoHelper *videoHelper;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *completeEditButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) WMShootingVideoViewController *shootingVideoViewController;

@end

NSString *const collectionViewCellIdentifier_3 = @"wm_collection_view_cell_identifier_3";

@implementation WMEditVideoViewController

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)modelManager shootingVideoViewController:(WMShootingVideoViewController *)shootingVideoViewController {
    self = [super init];
    
    if (self) {
        self.modelManager = modelManager;
        self.videoHelper = [[WMVideoHelper alloc] initWithVideoModelManager:self.modelManager];
        self.shootingVideoViewController = shootingVideoViewController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewComponents];
    [self setupConstraints];
}


#pragma mark - Create Views Methods

- (void)setupViewComponents {
    [self setupTitleView];
    [self setupBackButton];
    [self setupCompleteEditButton];
    [self setupCollectionView];
}

- (void)setupTitleView {
    self.titleView = [[UIView alloc] init];
    self.titleView.backgroundColor = [UIColor colorWithRed:0.15 green:0.16 blue:0.17 alpha:1.00];
    self.titleView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.titleView];
}

- (void)setupBackButton {
    self.backButton = [[UIButton alloc] init];
    [self.backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    self.backButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.titleView addSubview:self.backButton];
    [self.backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupCompleteEditButton {
    self.completeEditButton = [[UIButton alloc] init];
    [self.completeEditButton
     setImage:[UIImage imageNamed:@"Checkmark1"] forState:UIControlStateNormal];
    self.completeEditButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.completeEditButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.titleView addSubview:self.completeEditButton];
    [self.completeEditButton addTarget:self action:@selector(completeEditButtonButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.frame.size.width, 100);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.15 green:0.16 blue:0.17 alpha:1.00];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    //UICollectionView 객체에 register class 메소드로 재사용할 컬렉션뷰 셀을 설정
    //forCellWithReuseIdentifier를 사용해서 재사용할 셀의 식별자를 등록
    [self.collectionView registerClass:[WMVideoCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellIdentifier_3];
    
    [self.view addSubview:self.collectionView];
}


#pragma mark - Setup Constraints Methods

- (void)setupConstraints {
    [self setupTitleViewConstraints];
    [self setupBackButtonConstrains];
    [self setupCompleteEditButtonConstraints];
    [self setupCollectionViewConstraints];
}

- (void)setupTitleViewConstraints {
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titleView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"titleView" : self.titleView}]];
}

- (void)setupBackButtonConstrains {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[backButton(==40)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"backButton" : self.backButton}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[backButton(==40)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"backButton" : self.backButton}]];
    
    [self.titleView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.titleView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.backButton
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
}

- (void)setupCompleteEditButtonConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[completeEditButton(==33)]-20-|"
                                             options:0
                                             metrics:nil
                                               views:@{@"completeEditButton" : self.completeEditButton}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[completeEditButton(==33)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"completeEditButton" : self.completeEditButton}]];

}

- (void)setupCollectionViewConstraints {
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"collectionView" : self.collectionView}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleView(==50)][collectionView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"collectionView" : self.collectionView, @"titleView" : self.titleView}]];
}


#pragma mark - Collection view delegate methods

// 섹션에 있는 아이템 수 반환
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.modelManager.mediaDatas count];
}

// 참조되는 인덱스에 대한 적절한 셀 객체를 반환
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 재사용 큐에 셀을 가져온다
    WMVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellIdentifier_3 forIndexPath:indexPath];
    
    // 셀의 비디오 썸네일 설정
    cell.imageView.image = [self.videoHelper gettingThumbnailFromVideoInView:cell.imageView withURL:[(WMMediaModel *)self.modelManager.mediaDatas[indexPath.row] mediaURL]].image;
    
    cell.videoNumberLabel.text = [NSString stringWithFormat:@"%zd%@", indexPath.row + 1, @"번째 영상"];
    
    [cell.removeVideoButton addTarget:self action:@selector(removeVideoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILongPressGestureRecognizer *contentViewPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewLongPress:)];
    [cell.contentView addGestureRecognizer:contentViewPressRecognizer];
    
    return cell;
}


#pragma mark - Remove Video Button Event Handler Methods

- (void)removeVideoButtonClicked:(UIButton *)sender {
    UIView *senderButton = (UIView *)sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(UICollectionViewCell *)[[senderButton superview]superview]];
    
    // progress bar 뷰 업데이트
    self.shootingVideoViewController.shootingButton.progress -= [[self.shootingVideoViewController.progressArray objectAtIndex:indexPath.row] floatValue];
    [self.shootingVideoViewController.progressArray removeObjectAtIndex:indexPath.row];
    [self.modelManager removeObjectAtIndex:indexPath.row];
    [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    
    // count time 업데이트
    self.shootingVideoViewController.time += [[ self.shootingVideoViewController.countOutTimeArray objectAtIndex:indexPath.row] intValue];
    [self.shootingVideoViewController.countOutTimeArray removeObjectAtIndex:indexPath.row];
    self.shootingVideoViewController.recordingTimeCounter.text = [NSString stringWithFormat:@"%d", self.shootingVideoViewController.time];
}


#pragma mark - Content View Long Press Event Handler Methods

- (void)contentViewLongPress:(UILongPressGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView :self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    static UIView *snapshot = nil;
    static NSIndexPath *sourceIndexPath = nil;
    
    UIGestureRecognizerState state = gesture.state;
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
                // 선택된 셀의 스냅샷을 생성 후 콜렉션 뷰의 서브 뷰로 추가
                
                snapshot = [self snapshotFromView:cell];
                [self.collectionView addSubview:snapshot];
                snapshot.center = cell.center;
                
                cell.hidden = YES;
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                [self.modelManager.mediaDatas exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row]; // 데이터 업데이트
                [self.collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath :indexPath]; // 셀 이동
                sourceIndexPath = indexPath;
            }
            break;
        }
        default: {
            // Clean up.
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
            }];
            break;
        }
    }
}

// inputView를 인자로 받아 UIView로 만든 후 반환
- (UIView *)snapshotFromView:(UIView *)inputView {
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}


#pragma mark - Back Button Event Handler Methods

- (void)backButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WMEditVideoViewController dismiss" object:nil];
}


#pragma mark - Complete Edit Button Event Handler Methods

- (void)completeEditButtonButtonClicked:(UIButton *)sender {
    WMPlayAndApplyFilterViewController *playAndApplyFilterViewController =
    [[WMPlayAndApplyFilterViewController alloc] initWithVideoModelManager:self.modelManager];
    [self presentViewController:playAndApplyFilterViewController animated:YES completion:nil];
}

@end
