//
//  LWNameModel.h
//  LeWanProject
//
//  Created by iOS on 2021/3/17.
//  Copyright © 2021 mac. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LWNameModel : JSONModel
PropertyString(jiMing);
PropertyString(wuXing);
PropertyString(pinYin);
@end

NS_ASSUME_NONNULL_END
