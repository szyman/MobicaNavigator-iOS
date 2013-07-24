//
//  HintsViewController.m
//  MobicaiOS
//
//  Created by masy on 7/17/13.
//  Copyright (c) 2013 masy. All rights reserved.
//

#import "HintsViewController.h"

@interface HintsViewController ()

@end

@implementation HintsViewController

@synthesize hintsArray = _hintsArray;
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    webView.delegate = self;
    
    NSString *htmlString = @"<html><body>";
    for(NSString *hintString in [self hintsArray])
    {
        htmlString = [htmlString stringByAppendingString:hintString];
        htmlString = [htmlString stringByAppendingString:@"<br>"];
    }
    htmlString = [htmlString stringByAppendingString:@"</body></html>"];
    //NSLog(@"HTML: %@", htmlString);
    [webView loadHTMLString:htmlString baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
