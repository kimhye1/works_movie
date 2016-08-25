//
//  WMPlayAndApplyFilterViewController.m
//  WorksMovie
//
//  Created by Naver on 2016. 8. 15..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import "WMPlayAndApplyFilterViewController.h"
#import "WMVideoHelper.h"
#import "WMPlayAndStoreVideoViewController.h"
#import "WMFilterCollectionViewCell.h"
#import "WMFilters.h"
#import "WMFilter.h"
#import "WMNotificationStrings.h"

@interface WMPlayAndApplyFilterViewController ()

@property (nonatomic, strong) WMVideoModelManager *modelManager;
@property (nonatomic, strong) WMVideoHelper *videoHelper;
@property (nonatomic, strong) WMFilters *filters;
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIButton *backToCameraViewButton;
@property (nonatomic, strong) UIButton *completeButton;
@property (nonatomic, strong) UIView *filterContainerView;
@property (nonatomic, strong) UICollectionView *filterCollectionView;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) UILabel *saveAlertLabel;
@property (nonatomic, strong) NSArray *filterTitleList;
@property (nonatomic, strong) NSArray *filterNameList;
@property (nonatomic, strong) NSMutableArray *videoItems;
@property (nonatomic, strong) AVVideoComposition *videoComposition;
@property (nonatomic, strong) AVMutableComposition *composition;
@property (nonatomic, strong) NSURL *outputVideoURL;
@property (nonatomic, strong) WMFilter *curFilter;

@end

NSString *const collectionViewCellIdentifier = @"wm_collection_view_cell_identifier";

@implementation WMPlayAndApplyFilterViewController

- (instancetype)initWithVideoModelManager:(WMVideoModelManager *)modelManager {
    self = [super init];
    
    if (self) {
        self.modelManager = modelManager;
        self.videoHelper = [[WMVideoHelper alloc] initWithVideoModelManager:self.modelManager];
        self.filters = [[WMFilters alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewComponents];
    [self setupConstraints];
    
    self.composition = [self.videoHelper mergeVideo];
    [self exportVideo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActiveWhenDismissed:)
                                                 name:WMPlayAndStoreVideoViewControllerDidDismissedNotification object:nil];
}


#pragma mark - Create Views Methods

- (void)setupViewComponents {
    [self setupVideoView];
    [self setupBackToCameraViewButton];
    [self setupCompleteButton];
    [self setupFilterContainerView];
}

- (void)setupVideoView {
    self.videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-170)];
    self.videoView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.videoView];
}

- (void)setupBackToCameraViewButton {
    self.backToCameraViewButton = [[UIButton alloc] init];
    [self.backToCameraViewButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    self.backToCameraViewButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoView addSubview:self.backToCameraViewButton];
    [self.backToCameraViewButton addTarget:self action:@selector(backToCameraViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupCompleteButton {
    self.completeButton = [[UIButton alloc] init];
    [self.completeButton setImage:[UIImage imageNamed:@"Checkmark1"] forState:UIControlStateNormal];
    self.completeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoView addSubview:self.completeButton];
    [self.completeButton addTarget:self action:@selector(completeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupFilterContainerView {
    self.filterContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.filterContainerView.backgroundColor = [UIColor colorWithRed:0.15 green:0.16 blue:0.17 alpha:1.00];
    self.filterContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.filterContainerView];
    
    [self setupFilterScrollView];
}

- (void)setupFilterScrollView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(80, 90);
    
    self.filterCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.filterCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.filterCollectionView.backgroundColor = [UIColor colorWithRed:0.15 green:0.16 blue:0.17 alpha:1.00];
    self.filterCollectionView.delegate = self;
    self.filterCollectionView.dataSource = self;
    
    //UICollectionView 객체에 register class 메소드로 재사용할 컬렉션뷰 셀을 설정
    //forCellWithReuseIdentifier를 사용해서 재사용할 셀의 식별자를 등록
    [self.filterCollectionView registerClass:[WMFilterCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellIdentifier];
    
    [self.filterContainerView addSubview:self.filterCollectionView];
}


#pragma mark - Setup Constraints Methods

- (void)setupConstraints {
    [self setupVideoViewConstraints];
    [self setupBackToCameraViewButtonConstraints];
    [self setupCompleteButtonConstraints];
    [self setupFilterContainerViewConstraints];
    [self setupFilterScrollViewConstraint];
}

- (void)setupVideoViewConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[videoView]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"videoView" : self.videoView}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[videoView]-170-|"
                                             options:0
                                             metrics:nil
                                               views:@{@"videoView" : self.videoView}]];
}

- (void)setupBackToCameraViewButtonConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[backToCameraViewButton(==40)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"backToCameraViewButton" : self.backToCameraViewButton}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[backToCameraViewButton(==40)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"backToCameraViewButton" : self.backToCameraViewButton}]];
}

- (void)setupCompleteButtonConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[completeButton(==33)]-20-|"
                                             options:0
                                             metrics:nil
                                               views:@{@"completeButton" : self.completeButton}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[completeButton(==33)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"completeButton" : self.completeButton}]];
}

- (void)setupFilterContainerViewConstraints {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[filterContainerView]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"filterContainerView" : self.filterContainerView}]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[filterContainerView(==170)]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"videoView" : self.videoView, @"filterContainerView" : self.filterContainerView}]];
}

- (void)setupFilterScrollViewConstraint {
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[filterCollectionView(==100)]"
                                             options:0
                                             metrics:nil
                                               views:@{@"filterCollectionView" : self.filterCollectionView}]];
    
    [self.filterContainerView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.filterContainerView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.filterCollectionView
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];
    
    [self.filterContainerView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[filterCollectionView]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"filterCollectionView" : self.filterCollectionView}]];
}

- (void)exportVideo {
    NSString *outputVideoPath = [self outputPath];
    self.outputVideoURL = [NSURL fileURLWithPath:outputVideoPath];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:self.composition presetName:AVAssetExportPresetMediumQuality];
    
    exporter.outputURL = self.outputVideoURL;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = self.videoComposition;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        NSLog (@"created exporter. supportedFileTypes: %@", exporter.supportedFileTypes);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            switch ([exporter status]) {
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export failed: %@", [[exporter error] localizedDescription]);
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    break;
                case AVAssetExportSessionStatusCompleted:
                    NSLog(@"Export completed");
                    
                    [self playVideo:self.outputVideoURL];
                    
                    break;
                default:
                    break;
            }
        });
    }];
}

// 저장된 파일을 내보낼 path생성
- (NSString *)outputPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSString *outputVideoPath =  [documentsDirectory stringByAppendingPathComponent:
                                  [NSString stringWithFormat:@"%@%@", uuid, @".mov"]];
    return outputVideoPath;
}


#pragma mark - Play Video

- (void)playVideo:(NSURL *)outputVideoURL {

    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:outputVideoURL options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
    
    // 동영상 play가 끝나면 불릴 notification 등록
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.playerLayer.frame = self.videoView.frame;
    
    
    [self.videoView.layer insertSublayer:self.playerLayer below:self.backToCameraViewButton.layer];
    [self.player play];
}

- (void)itemDidFinishPlaying:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}


#pragma mark - Collection view delegate methods

// 섹션에 있는 아이템 수 반환
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.filters count];
}

// 참조되는 인덱스에 대한 적절한 셀 객체를 반환
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WMFilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellIdentifier forIndexPath:indexPath];
    
    // 선택 상태에 따른 셀UI 업데이트
    cell.filterImage.layer.borderColor = (cell.selected) ? [UIColor greenColor].CGColor : nil;
    cell.filterImage.layer.borderWidth = (cell.selected) ? 2.0f : 0.0f;

    NSString *filterTitle = [NSString stringWithFormat:@"%@", [(WMFilter *)self.filters.filters[indexPath.row] title]];
    cell.filterImage.image = [UIImage imageNamed:filterTitle];
    cell.filterNameLabel.text = filterTitle;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WMFilterCollectionViewCell *cell =  (WMFilterCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.filterImage.layer.borderColor = [UIColor greenColor].CGColor;
    cell.filterImage.layer.borderWidth = 2.0f;
    
    self.curFilter = [self.filters filterWithIndex:indexPath.row];
    AVAsset *asset = [AVAsset assetWithURL:self.outputVideoURL];
    
    
    __weak typeof(self) weakSelf = self;
    self.videoComposition = [AVVideoComposition videoCompositionWithAsset:asset
                                             applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest *request) {
                                                 
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     
                                                     CIImage *source = [request.sourceImage imageByClampingToExtent];
                                                     [weakSelf.curFilter.ciFilter setValue:source forKey:kCIInputImageKey];
                                                     
                                                     CIImage *output = [weakSelf.curFilter.ciFilter.outputImage imageByCroppingToRect:request.sourceImage.extent];
                                                     [request finishWithImage:output context:nil];
                                                     
                                                     weakSelf.playerItem.videoComposition = weakSelf.videoComposition;
                                                 });
                                             }];
    
    if (self.playerItem.videoComposition == nil) {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:[AVAsset assetWithURL:self.outputVideoURL]];
        playerItem.videoComposition = self.videoComposition;
        [self.player replaceCurrentItemWithPlayerItem:playerItem];
        [self.player play];
        
        // 동영상 play가 끝나면 불릴 notification 등록
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    }

}

// 델리게이트에게 특정 셀이 선택 해제되었다는 것을 알려준다.
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    WMFilterCollectionViewCell *cell =  (WMFilterCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.filterImage.layer.borderColor = nil;
    cell.filterImage.layer.borderWidth = 0.0f;
}


#pragma mark - Back to Camera Button Event Handler Methods

- (void)backToCameraViewButtonClicked:(UIButton *)sender {
   [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -  Complete Button Event Handler Methods

- (void)completeButtonClicked:(UIButton *)sender {
    [self.player pause];
    self.playerLayer.player = nil;
//    [self.playerLayer.player pause];
//    [self.playerLayer removeFromSuperlayer];
//    self.player = nil;

    [self presentWMPlayAndStoreVideoViewController];
}

- (void)presentWMPlayAndStoreVideoViewController {
    WMPlayAndStoreVideoViewController *playAndStoreVideoViewController =
    [[WMPlayAndStoreVideoViewController alloc] initWithVideoModelManager:self.modelManager
                                                             composition:self.videoComposition
                                                               outputURL:self.outputVideoURL
                                                                  filter:self.curFilter];
    [self presentViewController:playAndStoreVideoViewController animated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Notificatioin Handler Methods

- (void)applicationWillResignActive:(NSNotification *)notification {
    [self.player pause];
    self.playerLayer.player = nil;
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    self.playerLayer.player = self.player;
    [self.player play];
}

- (void)appDidBecomeActiveWhenDismissed:(NSNotification *)notice {
    self.playerLayer.player = self.player;
    [self.player play];
}

@end
