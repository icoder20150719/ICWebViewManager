//
//  ICWebViewManager.m
//  ICWebViewManager
//
//  Created by andy  on 15/8/18.
//  Copyright (c) 2015年 andy . All rights reserved.
//

#import "ICWebViewManager.h"
#import "NextViewController.h"




@interface ICSelectorObject : NSObject

@property (nonatomic,assign)SEL sel;
@property (nonatomic,assign)BOOL goAhead;
@property (nonatomic ,strong)id target;
@property (nonatomic ,copy)WebManagerBlock block;


@end

@implementation ICSelectorObject



@end

@interface ICWebViewManager ()<UIWebViewDelegate>
//观察的url
@property (nonatomic,strong)NSMutableDictionary *observers;

@property (nonatomic ,strong)UIWebView *webView;

@property (nonatomic ,assign)BOOL needTo;

@end


@implementation ICWebViewManager


static id instance ;
-(instancetype)initWithWebView:(UIWebView *)webView vewController:(UIViewController *)vc  delegate:(id)delegate
{
    if (self = [super init]) {
        self.webView = webView;
        webView.delegate = self;
        self.navigationController = vc.navigationController;
        self.delegate = delegate;
    }
    return self;

}



-(NSMutableDictionary *)observers
{
    if (!_observers) {
        _observers = [[NSMutableDictionary alloc]init];
    }
    return _observers;
}

-(void)addObserver:(id)observer forURLString:(NSString *)urlStr goAhead:(BOOL)goAhead performSelector:(SEL)sel
{
//    self.webView.delegate = self;
    ICSelectorObject *obj = [[ICSelectorObject alloc]init];
    obj.sel = sel;
    obj.target = observer;
    obj.goAhead = goAhead;
    [self.observers setObject:obj forKey:urlStr];
}
-(void)addObserverURLString:(NSString *)urlStr goAhead:(BOOL)goAhead usingBlock:(WebManagerBlock)block
{
    
    ICSelectorObject *obj = [[ICSelectorObject alloc]init];
    obj.block = block;
    obj.goAhead = goAhead;
    [self.observers setObject:obj forKey:urlStr];
}
-(void)removeObserverURLString:(NSString *)urlStr
{
    [self.observers removeObjectForKey:urlStr];
}
/**
 *  监听是否执行的URL
 *  @return 是否执行
 */
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlStr = request.URL.absoluteString;
    NSLog(@"%@",urlStr);
    
    if ([urlStr hasSuffix:@"/"]) {
        urlStr = [urlStr substringToIndex:urlStr.length - 1];
    }
    if ([urlStr isEqualToString:@"about:blank"]) {
        return NO;
    }
    if ([urlStr hasPrefix:@"tel:"]||[urlStr hasPrefix:@"msm:"]) {
        return YES;
    }
    //当前页面跳转
    if (urlStr.length > self.currentBaseUrlStr.length) {
    NSString * mach_urlStr =  [urlStr substringToIndex:self.currentBaseUrlStr.length ];
        if ([mach_urlStr isEqualToString:self.currentBaseUrlStr]) {
            return YES;
        }
    }
    
    
    if (self.isFirstViewController) {
        self.isFirstViewController = NO;
        return YES;
    }
    
    
    id obj = self.observers[urlStr];
    if (!obj) {
        //检测导航控制器有没有实现代理 实现了
        if ([self.navigationController respondsToSelector:@selector(dealWithUrlStr:)]) {
            return [self.navigationController dealWithUrlStr:urlStr];
        }
         return YES;
 
    }
    if ([obj isKindOfClass:[ICSelectorObject class]]) {
        ICSelectorObject * o = obj;
        if (o.block) {
            o.block();
        }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [o.target performSelector:o.sel];
#pragma clang clang diagnostic pop
        }
        //检测导航控制器有没有实现代理 实现了
        if ([self.navigationController respondsToSelector:@selector(dealWithUrlStr:)]) {
            return [self.navigationController dealWithUrlStr:urlStr];
        }
        return o.goAhead;
    }
    return NO;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:webView];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //添加js
    [self addJS];
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
    [self.delegate webViewDidFinishLoad:webView];
    }
    @try {
         [self divgetElementInnerByClassName:@"info"];
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        
    }
   
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:webView didFailLoadWithError:error];
    }
}
-(void)deleteDivBygetElementById:(NSString *)elementId
{
    NSString *det = [NSString stringWithFormat:@"deletedById('%@')",elementId];
    [self.webView stringByEvaluatingJavaScriptFromString:det];
    
}

-(void)deleteDivBygetElementByClassNameFirst:(NSString *)className{
    NSMutableString *mtg = [NSMutableString string];
    [mtg appendFormat:@"var chat =  document.getElementsByClassName('%@');",className];
    [mtg appendString:@"var cl = chat[0];"];
    [mtg appendString:@"if (cl != null);"];
    [mtg appendString:@"cl.parentNode.removeChild(cl);"];
    [self.webView stringByEvaluatingJavaScriptFromString:mtg];
}

-(void)deleteDivBygetElementByClassNameLast:(NSString *)className{
    NSMutableString *mtg = [NSMutableString string];
    [mtg appendFormat:@"var chat =  document.getElementsByClassName('%@');",className];
    [mtg appendString:@"var cl = chat[chat.length -1];"];
    [mtg appendString:@"if (cl != null);"];
    [mtg appendString:@"cl.parentNode.removeChild(cl);"];
    [self.webView stringByEvaluatingJavaScriptFromString:mtg];
}
-(void)deleteDivBygetElementByClassNameAll:(NSString *)className{
    NSMutableString *mtg = [NSMutableString string];
    [mtg appendFormat:@"var chat =  document.getElementsByClassName('%@');",className];
    [mtg appendString:@"var leng = chat.length;"];
    [mtg appendString:@"for (var i = 0; i < leng; ++i) {"];
    [mtg appendString:@"var cl = chat[0];"];
    [mtg appendString:@"if (cl != null);"];
    [mtg appendString:@"cl.parentNode.removeChild(cl);"];
    [mtg appendString:@"}"];
    [self.webView stringByEvaluatingJavaScriptFromString:mtg];
    
    
}
-(void)deleteDivBygetElementByTagNameFirst:(NSString *)className{
    NSMutableString *mtg = [NSMutableString string];
    [mtg appendFormat:@"var chat =  document.getElementsByTagName('%@');",className];
    [mtg appendString:@"var cl = chat[0];"];
    [mtg appendString:@"if (cl != null);"];
    [mtg appendString:@"cl.parentNode.removeChild(cl);"];
    [self.webView stringByEvaluatingJavaScriptFromString:mtg];
}

-(void)deleteDivBygetElementByTagNameLast:(NSString *)className{
    NSMutableString *mtg = [NSMutableString string];
    [mtg appendFormat:@"var chat =  document.getElementsByTagName('%@');",className];
    [mtg appendString:@"var cl = chat[chat.length -1];"];
    [mtg appendString:@"if (cl != null);"];
    [mtg appendString:@"cl.parentNode.removeChild(cl);"];
    [self.webView stringByEvaluatingJavaScriptFromString:mtg];
}
-(void)deleteDivBygetElementByTagNameAll:(NSString *)className{
    NSMutableString *mtg = [NSMutableString string];
    [mtg appendFormat:@"var chat =  document.getElementsByTagName('%@');",className];
    [mtg appendString:@"var leng = chat.length;"];
    [mtg appendString:@"for (var i = 0; i < leng; ++i) {"];
    [mtg appendString:@"var cl = chat[0];"];
    [mtg appendString:@"if (cl != null);"];
    [mtg appendString:@"cl.parentNode.removeChild(cl);"];
    [mtg appendString:@"}"];
    [self.webView stringByEvaluatingJavaScriptFromString:mtg];
}
-(NSString *)divgetElementInnerByClassName:(NSString *)name{
    NSMutableString *mtg = [NSMutableString string];
    [mtg appendFormat:@"var chat = document.getElementsByClassName('%@');",name];
    [mtg appendString:@"chat[0].innerText;"];
    NSString *str = [self.webView stringByEvaluatingJavaScriptFromString:mtg];
    return str;
}
-(NSString *)webCurrentHTML
{
     NSString *lJs = @"document.documentElement.innerHTML";//获取当前网页的html
    return [self.webView stringByEvaluatingJavaScriptFromString:lJs];
}
-(NSString *)webCurrentTitle{
    NSString *info = [self divgetElementInnerByClassName:@"info"];
    NSString *title = [self divgetElementInnerByClassName:@"title"];
    if(info.length == 0){
        return title;
    }else{
        return info;
    }
}

-(NSString *)webDocumentTitle{
return [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
-(NSString *)webCurrentURL{
    
    return [self.webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
}

-(void)addJS{
    //删除一个节点方法
    NSMutableString *mst = [NSMutableString string];
    [mst appendString:@"function deletedById(id){\n"];
    [mst appendString:@"var chat =  document.getElementById(id);\n"];
    [mst appendString:@"if (chat != null)\n"];
    [mst appendString:@"chat.parentNode.removeChild(chat);\n"];
    [mst appendString:@"}\n"];
    [self.webView stringByEvaluatingJavaScriptFromString:mst];
}


@end
