//
//  LZHPersonalCenterView.m
//  LZH_PersonalCenter
//
//  Created by admin  on 2018/7/21.
//  Copyright © 2018年 刘中华. All rights reserved.
//

#import "LZHPersonalCenterView.h"
#import "LZHPersonalCenterCell.h"
#import "LZHHeaderView.h"

@interface LZHPersonalCenterView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView ;
@property(nonatomic,strong)LZHHeaderView * headerView ;

/**
 内容
 */
@property(nonatomic,strong)NSArray * CenterArr ;

/**
 是否显示数组
 */
@property(nonatomic,assign)BOOL isShowHeader ;

@end

@implementation LZHPersonalCenterView

-(instancetype)initWithFrame:(CGRect)frame CenterArr:(NSArray *)CenterArr isShowHeader:(BOOL)isShowHeader{
    if ([super initWithFrame:frame]) {
        self.CenterArr = CenterArr ;
        self.isShowHeader = isShowHeader ;
        [self addSubview:self.tableView ];
    }
    return self ;
}

//说明数组
-(void)setExtendCenterRightArr:(NSArray *)extendCenterRightArr{
    _extendCenterRightArr = extendCenterRightArr ;
}

#pragma mark--tableView代理
//设置多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.CenterArr.count ;
}

//设置每组有多少个Row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * rowArr = self.CenterArr[section];
    return rowArr.count ;
}

//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LZHPersonalCenterCell * cell = [tableView dequeueReusableCellWithIdentifier:@"pcCell" forIndexPath:indexPath] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
//    cell.backgroundColor = [UIColor colorWithRed:(arc4random() % 256)/255.0 green:(arc4random() % 256)/255.0 blue:(arc4random() % 256)/255.0 alpha:1] ;
    //传值
    NSArray * rowArr = self.CenterArr[indexPath.section];
    cell.centerNS = rowArr[indexPath.row] ;
    //扩展说明内容
    NSArray * extendArr = self.extendCenterRightArr[indexPath.section] ;
    cell.extendCenterRightNS = extendArr[indexPath.row] ;
    
    //最后一个底线全长
    if (indexPath.row==rowArr.count-1) {
        cell.bottomLinkLong = @"Long" ;
    }
    return cell ;
}

#pragma mark--点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * rowArr = self.CenterArr[indexPath.section];
//    NSLog(@"点击：---  %@",rowArr[indexPath.row]) ;
    if ([self.delegate respondsToSelector:@selector(didSelectRowTitle:)]) {
        [self.delegate didSelectRowTitle:rowArr[indexPath.row]];
    }
}

#pragma mark--头部事件
-(void)tapHeaderClick{
    if ([self.delegate respondsToSelector:@selector(tapHeader)]) {
        [self.delegate tapHeader];
    }
}

//头部
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isShowHeader && section==0) {
        return 120 ;
    }
   
    return 0.01f ;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.isShowHeader && section==0) {
        return self.headerView;
    }
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0.01)];
    return headerView;
}

//底部
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15 ;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 15)];
    return headerView;
}


#pragma mark--懒加载
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.frame];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor] ;
        _tableView.dataSource = self ;
        _tableView.delegate = self ;
        _tableView.rowHeight = 45 ;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
        [_tableView registerClass:[LZHPersonalCenterCell class] forCellReuseIdentifier:@"pcCell"];
    }
    return _tableView ;
}

-(LZHHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [LZHHeaderView intHeaderView];
        _headerView.frame = CGRectMake(0, 0, self.frame.size.width, 120) ;
        [_headerView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeaderClick)]];
    }
    return _headerView ;
}

@end
