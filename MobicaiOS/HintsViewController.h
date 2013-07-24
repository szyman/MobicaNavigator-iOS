//
//  HintsViewController.h
//  MobicaiOS
//
//  Created by masy on 7/17/13.
//  Copyright (c) 2013 masy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface HintsViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) NSArray *hintsArray;

@end
