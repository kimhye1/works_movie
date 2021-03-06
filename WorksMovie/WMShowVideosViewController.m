//
//  WMShowVideosController.m
//  WorksMovie
//
//  Created by Naver on 2016. 6. 29..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMShowVideosViewController.h"
#import "WMCollectionViewCell.h"
#import <Photos/Photos.h>
#import "WMRecordAudioViewController.h"
#import "WMNotificationStrings.h"

@interface WMShowVideosViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) PHImageManager *imageManager;
@property (nonatomic, strong) PHFetchResult *fetchResult;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UICollectionViewCell *cell;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *userGuideLabel;

@end

NSString *const kCollectionViewCellIdentifier = @"wm_collection_view_cell_identifier";

@implementation WMShowVideosViewController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self fetchAssets];
        [self initializeImageManager];
    }
    return self;
}

- (void)fetchAssets {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    self.fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:options];
}

- (void)initializeImageManager {
    self.imageManager = [[PHImageManager alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewComponents];
    [self setupConstraints];
}


#pragma mark - Create Views Methods

- (void)setupViewComponents {
    [self setupTitleView];
    [self setupCollectionView];
    [self setupSelectButton];
}

- (void)setupTitleView {
    self.titleView = [[UIView alloc] init];
    self.titleView.backgroundColor = [UIColor colorWithRed:0.15 green:0.16 blue:0.17 alpha:1.00];
    self.titleView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.titleView];
    
    [self setupBackButton];
    [self setupTitle];
}

- (void)setupBackButton {
    self.backButton = [[UIButton alloc] init];
    [self.backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    self.backButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.titleView addSubview:self.backButton];
    [self.backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupTitle {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"내 동영상";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.titleView addSubview:self.titleLabel];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(155, 155);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.15 green:0.16 blue:0.17 alpha:1.00];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    //UICollectionView 객체에 register class 메소드로 재사용할 컬렉션뷰 셀을 설정
    //forCellWithReuseIdentifier를 사용해서 재사용할 셀의 식별자를 등록
    [self.collectionView registerClass:[WMCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
    
    [self.view addSubview:self.collectionView];
}

- (void)setupSelectButton {
    self.selectButton = [[UIButton alloc] init];
    [self.selectButton setImage:[UIImage imageNamed:@"checkButton"] forState:UIControlStateNormal];
    self.selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.selectButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    self.selectButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.collectionView.superview addSubview:self.selectButton];
    self.selectButton.hidden = YES;
}

- (void)setupUserGuidLabel {
    self.userGuideLabel = [[UILabel alloc] init];
    self.userGuideLabel.text = @"버튼을 눌러 영상에 후시녹음을 해보세요";
    self.userGuideLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7f];
    [self.userGuideLabel setFont:[UIFont systemFontOfSize:12]];
    self.userGuideLabel.layer.cornerRadius = 6;
    self.userGuideLabel.clipsToBounds = YES;
    self.userGuideLabel.textAlignment = NSTextAlignmentCenter;
    self.userGuideLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.collectionView.superview addSubview:self.userGuideLabel];
}


#pragma mark - Setup Constraints Methods

- (void)setupConstraints {
    [self setupTitleViewConstraints];
    [self setupBackButtonConstrains];
    [self setupTitleConstraints];
    [self setupCollectionViewConstraints];
    [self setupSelectButtonConstraints];
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

- (void)setupTitleConstraints {
    [self.titleView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.titleView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.titleLabel
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]];
    
    [self.titleView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.titleView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.titleLabel
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
    
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

- (void)setupSelectButtonConstraints {
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[selectButton(==80)]-35-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"selectButton" : self.selectButton}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[selectButton(==80)]-35-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"selectButton" : self.selectButton}]];
}

- (void)setupUserGuideLabelConstraints {
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[userGuideLabel(==207)]-10-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"userGuideLabel" : self.userGuideLabel}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[userGuideLabel(==37)]-120-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"userGuideLabel" : self.userGuideLabel}]];
}


#pragma mark - Collection view delegate methods

// 섹션에 있는 아이템 수 반환
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.fetchResult count];
}

// 참조되는 인덱스에 대한 적절한 셀 객체를 반환
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 재사용 큐에 셀을 가져온다
    WMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];
    
    // 선택 상태에 따른 셀UI 업데이트
    cell.layer.borderColor = (cell.selected) ? [UIColor colorWithRed:0.21 green:0.62 blue:0.13 alpha:1.00].CGColor : nil;
    cell.layer.borderWidth = (cell.selected) ? 5.0f : 0.0f;
    cell.imageView.image = nil;
    
    PHAsset *asset = self.fetchResult[indexPath.item];
    [self.imageManager requestImageForAsset:asset
                                 targetSize:collectionView.collectionViewLayout.collectionViewContentSize
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  cell.imageView.image = result;

                              }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    self.cell.layer.borderColor = [UIColor colorWithRed:0.21 green:0.62 blue:0.13 alpha:1.00].CGColor;
    self.cell.layer.borderWidth = 5.0f;
    self.selectButton.hidden = NO;

    self.selectButton.titleLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)indexPath.row];
    self.selectButton.titleLabel.hidden = YES;
    [self.selectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self checkIsInitialEntry];
}

// 델리게이트에게 특정 셀이 선택 해제되었다는 것을 알려준다.
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    self.cell.layer.borderColor = nil;
    self.cell.layer.borderWidth = 0.0f;
    
    self.selectButton.hidden = YES;
}


#pragma mark - Check Is Initial Entry

- (void)checkIsInitialEntry {
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    if ([userDefault valueForKey:@"isInitialInWMShowVideosViewController"] == false) {   // 앱을 처음 실행한 상태
//        [userDefault setBool:false forKey:@"isInitialInWMShowVideosViewController"];
    
        [self setupUserGuidLabel];
        [self setupUserGuideLabelConstraints];
//    }
}


#pragma mark - Back Button Event Handler Methods

- (void)backButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WMShootingVideoViewControllerDidDismissedNotification object:nil];
}


#pragma mark - Select Button Event Handler Methods

- (void)selectButtonClicked:(UIButton *)sender {
    [self presentRecordVideoViewController];
}

// 선택된 cell의 indexPath를 이용해 PHAsset을 생성한 후 AVAsset으로 변환해 url을 추출한다. 그 값을 WMRecordAudioViewController로 전달한다.
- (void)presentRecordVideoViewController {
    NSString *videoString = self.selectButton.titleLabel.text;
    
    PHAsset *asset = [self.fetchResult objectAtIndex:[videoString intValue]];
    
    __weak typeof(self) weakSelf = self;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset *avAsset, AVAudioMix *audioMix, NSDictionary *info) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.URL = [(AVURLAsset *)avAsset URL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            WMRecordAudioViewController *recordAudioViewController = [[WMRecordAudioViewController alloc] initWithVideoURL:strongSelf.URL];
            [strongSelf presentViewController:recordAudioViewController animated:NO completion:nil];
        });
    }];
}

@end
