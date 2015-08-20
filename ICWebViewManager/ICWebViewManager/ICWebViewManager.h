//
//  ICWebViewManager.h
//  ICWebViewManager
//
//  Created by andy  on 15/8/18.
//  Copyright (c) 2015年 andy . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ICViewControllerRecord.h"
#import "ICConst.h"
typedef void(^WebManagerBlock)();

@protocol ICWebViewManagerNavigationDelegate <NSObject>
@optional
-(BOOL)dealWithUrlStr:(NSString *)urlStr;

@end

@protocol ICWebViewManagerDelegate <NSObject>
@optional
- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

@end

@interface ICWebViewManager : NSObject

@property (nonatomic ,weak)id<ICWebViewManagerDelegate>delegate;
@property (nonatomic ,weak)id<ICWebViewManagerNavigationDelegate>navigationController;
@property (nonatomic ,assign)BOOL isFirstViewController;
@property (nonatomic ,copy)NSString *currentBaseUrlStr;

-(instancetype)initWithWebView:(UIWebView *)webView vewController:(UIViewController *)vc delegate:(id)delegate;
-(void)addObserver:(id)observer forURLString:(NSString *)urlStr goAhead:(BOOL)goAhead performSelector:(SEL)sel;
-(void)addObserverURLString:(NSString *)urlStr goAhead:(BOOL)goAhead usingBlock:(WebManagerBlock)block;
-(void)removeObserverURLString:(NSString *)urlStr;
-(void)deleteDivBygetElementById:(NSString *)elementId;
-(void)deleteDivBygetElementByClassNameFirst:(NSString *)className;
-(void)deleteDivBygetElementByClassNameLast:(NSString *)className;
-(void)deleteDivBygetElementByClassNameAll:(NSString *)className;
-(void)deleteDivBygetElementByTagNameFirst:(NSString *)className;
-(void)deleteDivBygetElementByTagNameLast:(NSString *)className;
-(void)deleteDivBygetElementByTagNameAll:(NSString *)className;
-(NSString *)webCurrentHTML;
-(NSString *)webCurrentTitle;
-(NSString *)webDocumentTitle;
-(NSString *)webCurrentURL;

@end;
