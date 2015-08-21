//
//  NavigationController.m
//  ICWebViewManager
//
//  Created by andy  on 15/8/19.
//  Copyright (c) 2015年 andy . All rights reserved.
//

#import "NavigationController.h"
#import "ICWebViewManager.h"
#import "NextViewController.h"

@interface NavigationController ()<ICWebViewManagerNavigationDelegate>

//请求过的ViewController
@property (nonatomic,strong)NSMutableArray *urlViewController;
@property (nonatomic,assign)BOOL isFirstViewController;
@end

@implementation NavigationController
-(NSMutableArray *)urlViewController
{
    if (!_urlViewController) {
        _urlViewController = [[NSMutableArray alloc]init];
    }
    return _urlViewController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.urlViewController removeAllObjects];
    
    return [super popViewControllerAnimated:animated];
}
-(NSArray *)popToRootViewControllerAnimated:(BOOL)animated{
    [self.urlViewController removeAllObjects];
    return [super popToRootViewControllerAnimated:animated];
}
-(BOOL)dealWithUrlStr:(NSString *)urlStr
{
    NextViewController *nextVc = [[NextViewController alloc]init];
    nextVc.urlStr = urlStr;
   
        //获取历史的ViewController
        __block  BOOL march = NO;
        __block ICViewControllerRecord *re ;
        __block  NSInteger index = 0 ;
        [self.urlViewController enumerateObjectsUsingBlock:^(ICViewControllerRecord *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.url isEqualToString:urlStr]) {
                re = obj;
                march = YES;
                index = idx;
                *stop = YES;
            }
        }];
    NSLog(@"%ld --- %ld",index,self.urlViewController.count - 1);

    
        if (march ){
            [self.urlViewController removeObjectAtIndex:index];
            return YES;
        }else{
            
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            CFAbsoluteTime t2 = CFAbsoluteTimeGetCurrent();
           NSNumber *b = [def objectForKey:@"t1"];
            CFAbsoluteTime getT = [b doubleValue];
//            NSLog(@"%f,",t2 - getT);
            if (t2 - getT < 1.5) {//小聪明验证
                return YES;
            }
            
            CFAbsoluteTime t1 = CFAbsoluteTimeGetCurrent();
            [def setObject:@(t1) forKey:@"t1"];
            [def synchronize];
            
            [self pushViewController:nextVc animated:YES];
            ICViewControllerRecord *record = [[ICViewControllerRecord alloc]init];
            record.url = urlStr;
            record.vc = nextVc;
            [self.urlViewController addObject:record];
        }
    

    return NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
