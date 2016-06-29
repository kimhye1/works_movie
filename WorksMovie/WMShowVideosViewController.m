//
//  WMShowVideosController.m
//  WorksMovie
//
//  Created by Naver on 2016. 6. 29..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMShowVideosViewController.h"
#import "WMCollectionViewCell.h"

@interface WMShowVideosViewController ()

@property (nonatomic, strong) NSMutableArray *dummyImages;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

NSString *const wm_collection_view_cell_identifier = @"wm_collection_view_cell_identifier";

@implementation WMShowVideosViewController

- (instancetype)init {
    self = [super init];
    
    if(self) {
        [self initializeAssets];
    }
    return self;
}

- (void)initializeAssets {
    self.dummyImages = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0 ; i < 20 ; i ++) {
        [self.dummyImages addObject:[UIImage imageNamed:@"tropical"]];
    }
}

- (void)viewDidLoad {
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
    
    [self.collectionView registerClass:[WMCollectionViewCell class] forCellWithReuseIdentifier:wm_collection_view_cell_identifier];
    
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
    return [self.dummyImages count];
}

// 참조되는 인덱스에 대한 적절한 셀 객체를 반환
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //재사용 큐에 셀을 가져온다
    WMCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:wm_collection_view_cell_identifier forIndexPath:indexPath];
    
    //표시할 이미지 설정
    collectionViewCell.imageView.image = self.dummyImages[indexPath.item];
    
    return collectionViewCell;
}



@end
