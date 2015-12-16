//
//  common.h
//  todo
//
//  Created by qxli on 15/10/19.
//  Copyright © 2015年 qxli. All rights reserved.
//

#ifndef common_h
#define common_h

/**
 *  屏幕参数
 */
#define CC_Screen_Scale [[UIScreen mainScreen] scale]
#define CC_Screen_Bounds [[UIScreen mainScreen] bounds]
#define CC_Screen_Width CC_Screen_Bounds.size.width
#define CC_Screen_Height CC_Screen_Bounds.size.height


/**
 *  缩放比
 */
#define CC_Factor_iPhone6p_414 (CC_Screen_Bounds.size.width/414.0f)
#define CC_Factor_iPhone6_375 (CC_Screen_Bounds.size.width/375.0f)
#define CC_Factor_iPhone5s_320 (CC_Screen_Bounds.size.width/320.0f)

#define UIColorFromHex(s) \
    [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 \
                    green:(((s & 0xFF00) >> 8))/255.0 \
                     blue:((s & 0xFF))/255.0  alpha:1.0]

#import "logger.h"

#endif /* common_h */
