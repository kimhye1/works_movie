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

@interface WMShowVideosViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) PHImageManager *imageManager;
@property (nonatomic, strong) PHFetchResult *fetchResult;

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
    //test commit
    [super viewDidLoad];
    
    [self setupComponents];
    [self setupConstraints];
}

- (void)setupComponents {
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

- (void)setupConstraints {
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"collectionView" : self.collectionView}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"collectionView" : self.collectionView}]];
}

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
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    cell.layer.borderColor = [UIColor yellowColor].CGColor;
    cell.layer.borderWidth = 5.0f;
}

// 델리게이트에게 특정 셀이 선택 해제되었다는 것을 알려준다.
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    cell.layer.borderColor = nil;
    cell.layer.borderWidth = 0.0f;
}



@end
