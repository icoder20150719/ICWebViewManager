//
//  ViewController.m
//  ICWebViewManager
//
//  Created by andy  on 15/8/18.
//  Copyright (c) 2015年 andy . All rights reserved.
//

#import "ViewController.h"
#import "ICWebViewManager.h"
#import "ICConst.h"

@interface ViewController ()<ICWebViewManagerDelegate>
@property (strong ,nonatomic)UIWebView *webView;
@property (strong ,nonatomic)ICWebViewManager *webMgr;
@property (strong ,nonatomic)UILabel *lable;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建WebView
    UIWebView *web = [[UIWebView alloc]initWithFrame:self.view.bounds];
    web.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height) ;
    [self.view addSubview:web];
    self.webView = web;
    web.hidden = YES;
    
    ICWebViewManager *webMgr = [[ICWebViewManager alloc]initWithWebView:web  vewController:self delegate:self];
    webMgr.isFirstViewController = YES;

    self.webMgr = webMgr;
    [webMgr addObserver:self forURLString:@"http://www.baidu.com" goAhead:NO performSelector:@selector(goBaidu)];
    [webMgr addObserverURLString:@"http://www.jd.com"  goAhead:NO usingBlock:^{
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"点了京东" message:@"做的什么" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [al show];
    }];
    
    [webMgr addObserverURLString:@"http://m.dianping.com/tuan/buy/13303092"  goAhead:YES usingBlock:^{
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"点了立即购买" message:@"做的什么呢" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [al show];
    }];
    
    
    [self loadWebView];
    
//   UIButton *btn = [[UIButton alloc]init];
//    [btn setTitle:@"删除一个节点" forState:UIControlStateNormal];
//    btn.frame = CGRectMake(100, 100, 110, 20);
//    [btn setBackgroundColor:[UIColor redColor]];
//    [self.view addSubview:btn];
//    [btn addTarget:self action:@selector(deleteElement) forControlEvents:UIControlEventTouchUpInside];
//    UILabel *lable = [[UILabel alloc]init];
//    lable.frame = CGRectMake(0, 100, self.view.frame.size.width, 30);
//    lable.textAlignment = NSTextAlignmentCenter;
//    lable.textColor = [UIColor whiteColor];
//    lable.backgroundColor = [UIColor redColor];
//    self.lable = lable;
////    [self.view addSubview:lable];
//    [self.view insertSubview:lable belowSubview:web];

    // Do any additional setup after loading the view, typically from a nib.
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.hidden = NO;
    //用于直接删除
    //    [self deleteElement];
    self.title = self.webMgr.webCurrentTitle;
    self.lable.text = webView.request.mainDocumentURL.absoluteString;;
    NSLog(@"标题：%@ \n 地址：%@ ",self.webMgr.webCurrentTitle,self.webMgr.webCurrentURL);
    //    NSLog(@"%@",self.webMgr.webCurrentHTML);
    //删除header
    [self.webMgr deleteDivBygetElementByTagNameAll:@"header"];
    //删除footer
    [self.webMgr deleteDivBygetElementByClassNameAll:@"footer"];
    //删除返回按钮
    [self.webMgr deleteDivBygetElementByClassNameFirst:@"back back-gray"];
    self.title = @"安哥的团购app";
}

- (void)goBaidu {
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"点了百度" message:@"做点什么" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [al show];
}
-(void)loadWebView{
//   NSString *path = [[NSBundle mainBundle]pathForResource:@"index.html" ofType:nil];
//    NSURL *url = [[NSURL alloc]initFileURLWithPath:path];
//    NSURL *url = [NSURL URLWithString:@"http://m.dianping.com/tuan/deal/13247658"];
    NSURL *url = [NSURL URLWithString:BASEDomain];
    self.webMgr.currentBaseUrlStr = BASEDomain;
//     NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

-(void)deleteElement{
    [self.webMgr deleteDivBygetElementById:@"text1"];
}

@end
