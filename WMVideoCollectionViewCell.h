//
//  WMVideoCollectionViewCell.h
//  WorksMovie
//
//  Created by Naver on 2016. 8. 12..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMVideoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *removeVideoButton;
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UILabel *videoNumberLabel;

@end
