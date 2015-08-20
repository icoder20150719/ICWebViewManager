//
//  NextViewController.m
//  ICWebViewManager
//
//  Created by andy  on 15/8/19.
//  Copyright (c) 2015年 andy . All rights reserved.
//

#import "NextViewController.h"
#import "ICWebViewManager.h"

@interface NextViewController ()<ICWebViewManagerDelegate,UIWebViewDelegate>
@property (nonatomic ,strong)UIWebView *webView;
@property (strong ,nonatomic)ICWebViewManager *webMgr;
@property (strong ,nonatomic)UIActivityIndicatorView *actView;
@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //创建WebView
    UIWebView *web = [[UIWebView alloc]initWithFrame:self.view.bounds];
    web.delegate = self;
    web.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ;
    [self.view addSubview:web];
    self.webView = web;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    self.webView.hidden = YES;
    ICWebViewManager *webMgr = [[ICWebViewManager alloc]initWithWebView:self.webView  vewController:self delegate:self];
    self.webMgr = webMgr;
    webMgr.currentBaseUrlStr = self.urlStr;
    UIActivityIndicatorView *actView = [[UIActivityIndicatorView  alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [actView startAnimating];
    actView.center = self.view.center;
    [self.view addSubview:actView];
    self.actView = actView;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
  
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
   
    [self.actView removeFromSuperview];
    self.title = self.webMgr.webCurrentTitle;
    //删除header
    [self.webMgr deleteDivBygetElementByTagNameAll:@"header"];
    //删除footer
    [self.webMgr deleteDivBygetElementByClassNameAll:@"footer"];
    //删除返回按钮
    [self.webMgr deleteDivBygetElementByClassNameFirst:@"back back-gray"];
    self.webView.hidden = NO;
//    NSLog(@"%@",self.webMgr.webCurrentHTML);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
