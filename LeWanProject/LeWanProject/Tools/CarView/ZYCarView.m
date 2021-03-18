//
//  ZYCarView.m
//  ZYCarView
//
//  Created by liqiaona on 2018/3/8.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import "ZYCarView.h"
#import "ZYCarViewLayout.h"
#import "ZYCarCollectionViewCell.h"

@interface ZYCarView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)ZYCarViewLayout *carViewLayout;
@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGFloat lasttimePoint;
@end
@implementation ZYCarView
#pragma mark- lazy
-(NSMutableArray *)array{
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
}
-(UICollectionView* )collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.carViewLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"ZYCarCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"item"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        
    }
    return _collectionView;
}

-(ZYCarViewLayout *)carViewLayout{
    if (!_carViewLayout) {
        _carViewLayout = [[ZYCarViewLayout alloc]init];
        _carViewLayout.itemSize = CGSizeMake(self.viewSize.height*0.8, self.viewSize.height*0.8);
        _carViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _carViewLayout;
}

#pragma mark- init
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.viewSize = self.frame.size;
        [self addSubview:self.collectionView];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    [self setSlideEnd];
}

/**
 回到屏幕正中间
 */
-(void)setSlideEnd{
    CGPoint collectionViewPoint = self.collectionView.contentOffset;
   
    CGFloat viewWidth = CGRectGetWidth(self.collectionView.frame);
    CGFloat itemHeight = self.viewSize.height*0.8;
    CGFloat index = roundf((self.collectionView.contentOffset.x) /viewWidth);
    collectionViewPoint.x = itemHeight * index;
    [self.collectionView setContentOffset:collectionViewPoint animated:YES];
  
}

-(void)setArrayData:(NSArray *)array superScrollView:(UIScrollView *)superScrollView{
    
    [self.array removeAllObjects];
    if (array.count<=0) {
        return;
    }
    [self.array addObjectsFromArray:array];
    NSInteger index = 10;
    for (int i = 0; i<index; i++) {
        [self.array addObjectsFromArray:self.array];
    }

}
-(void)setArraypinyin:(NSArray *)PYarray name:(NSArray *)nameArr wuxing:(NSArray *)wuxingArr superScrollView:(UIScrollView *)superScrollView{
    
}

#pragma mark- UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZYCarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    [cell setModel:[self.array objectAtIndex:indexPath.item]];
   
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZYCarModel *model =[self.array objectAtIndex:indexPath.item];
    if (self.block) {
        self.block(model.nameStr);
    }
}
#pragma mark- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x<300) {
        CGPoint point = CGPointMake(0+(self.array.count/2*self.frame.size.height*0.8),
                                    self.collectionView.contentOffset.y);
        [self.collectionView setContentOffset:point animated:NO];
    }else if (scrollView.contentOffset.x>(self.array.count*self.frame.size.height*0.8)-500){
        CGPoint point = CGPointMake(0+(self.array.count/2*self.frame.size.height*0.8),
                                    self.collectionView.contentOffset.y);
        [self.collectionView setContentOffset:point animated:NO];
    }
}
@end
