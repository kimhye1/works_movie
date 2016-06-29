//
//  WMShowVideosController.h
//  WorksMovie
//
//  Created by Naver on 2016. 6. 29..
//  Copyright © 2016년 worksmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

//컬렉션 뷰 인스턴스는 데이터 소스 객체와 델리게이트 객체가 필요하므로 UICollectionViewDataSource와 UICollectionViewDelegate 프로토콜을 구현하곘다고 선언
@interface WMShowVideosViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@end
