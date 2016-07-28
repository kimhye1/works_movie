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

@interface WMShowVideosViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) PHImageManager *imageManager;
@property (nonatomic, strong) PHFetchResult *fetchResult;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UICollectionViewCell *cell;
@property (nonatomic, strong) NSURL *URL;


@end

NSString *const kCollectionViewCellIdentifier = @"wm_collection_view_cell_identifier";

@implementation WMShowVideosViewController

- (instancetype)init {
    self = [super init];
    
    if(self) {
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
    
    [self setupComponents];
    [self setupConstraints];
}


#pragma mark - Create Views Methods

- (void)setupComponents {
    [self setupCollectionView];
    [self setupSelectButton];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(155, 155);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
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


#pragma mark - Setup Constraints Methods

- (void)setupConstraints {
    [self setupCollectionViewConstraints];
    [self setupSelectButtonConstraints];
}

- (void)setupCollectionViewConstraints {
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"collectionView" : self.collectionView}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"collectionView" : self.collectionView}]];
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


#pragma mark - Collection view delegate methods

// 컬렉션 뷰의 지정된 섹션에 표시되어야 할 항목의 개수 반환
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 섹션에 있는 아이템 수 반환
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.fetchResult count];
}

// 참조되는 인덱스에 대한 적절한 셀 객체를 반환
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 재사용 큐에 셀을 가져온다
    WMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];
    
    // 선택 상태에 따른 셀UI 업데이트
    cell.layer.borderColor = (cell.selected) ? [UIColor yellowColor].CGColor : nil;
    cell.layer.borderWidth = (cell.selected) ? 5.0f : 0.0f;
    
    
    
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

// 특정 셀이 tap 되었을때 호출
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    self.cell.layer.borderColor = [UIColor yellowColor].CGColor;
    self.cell.layer.borderWidth = 5.0f;
    self.selectButton.hidden = NO;

    self.selectButton.titleLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)indexPath.row];
    self.selectButton.titleLabel.hidden = YES;
    [self.selectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

// 델리게이트에게 특정 셀이 선택 해제되었다는 것을 알려준다.
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    self.cell.layer.borderColor = nil;
    self.cell.layer.borderWidth = 0.0f;
    
    self.selectButton.hidden = YES;
}


#pragma mark - Select Button Event Handler Methods

- (void)selectButtonClicked:(UIButton *)sender {
    [self presentRecordVideoViewController];
}

// 선택된 cell의 indexPath를 이용해 PHAsset을 생성한 후 AVAsset으로 변환해 url을 추출한다. 그 값을 WMRecordAudioViewController로 전달한다.
- (void)presentRecordVideoViewController {
    NSString *videoString = self.selectButton.titleLabel.text;
    
    PHAsset *asset = [self.fetchResult objectAtIndex:[videoString intValue]];
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset *avAsset, AVAudioMix *audioMix, NSDictionary *info) {
        self.URL = [(AVURLAsset *)avAsset URL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            WMRecordAudioViewController *recordAudioViewController = [[WMRecordAudioViewController alloc] initWithVideoURL:self.URL];
            [self presentViewController:recordAudioViewController animated:NO completion:nil];
        });
    }];
}

@end
