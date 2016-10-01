//
//  ComboArray.m
//  LuckyDoubleColorBall
//
//  Created by lyfscb on 16/10/1.
//  Copyright © 2016年 LK. All rights reserved.
//

#import "ComboArray.h"
#import <math.h>
@implementation ComboArray

+(NSArray*)comboArray:(NSArray*)source m:(int)m{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    int size =[ComboArray getCnm:source.count m:m  ];
    for (int i=0; i<size; i++){
        NSArray* data = [ComboArray getValue:source m:m x:i];
        [array addObject:data];
    }
    return array;
}
+(NSArray*)getValue:(NSArray*)array m:(int)m x:(int)x{
    // 数组大小
    int n = array.count;
    // 存储组合数
    NSMutableArray* sb = [[NSMutableArray alloc]init];
    int start = 0;
    while(m > 0){
        if (m == 1){
            // m == 1 时为组合数的最后一个字符
  
//            [sb appendFormat:@"%@,",array[start+x] ];
            [sb addObject:array[start+x]];
            break;
        }
        for (int i=0; i<=n-m; i++){
//            int cnm =  (int)getCnm(n-1-i,m-1);
            int cnm =   [ComboArray getCnm:n-1 m:m-1 ];
            if(x <= cnm-1){
                     [sb addObject:array[start+x]];
                // 启始下标前移
                start = start + (i + 1);
                // 搜索区域减小
                n = n - (i+1);
                // 组合数的剩余字符个数减少
                m--;
                break;
            } else {
                x = x - cnm;
            }
        }
    }
    
  

    
    [sb sortUsingComparator:^NSComparisonResult(NSNumber*   obj1, NSNumber* obj2) {
        if (obj1.integerValue > obj2.integerValue) {
            return NSOrderedDescending;
        }else
        if (obj1.integerValue < obj2.integerValue) {
            return NSOrderedAscending;
        }
       else {
            return NSOrderedSame;
        }
    }];
    
    
    return sb;
}

+(int)getCnm:(int)n m:(int)m{
    if (n < 0 || m < 0){
        return 0;
    }
    if (n == 0 || m == 0){
        return 1;
    }
    if (m > n){
        return 0;
    }
    if (m > n/2.0){
        m = n-m;
    }
    double result = 0.0;
    for (int i = n; i>=(n-m+1); i--){
        result += log(i);
    }
    for (int i=m; i>=1; i--){
        result -= log(i);
    }
    result = exp(result);
    return round(result);
}
@end
