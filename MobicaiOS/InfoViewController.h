//
//  InfoViewController.h
//  MobicaiOS
//
//  Created by masy on 7/8/13.
//  Copyright (c) 2013 masy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UINavigationItem *titleBar;

@property (weak, nonatomic) IBOutlet UIImageView *imageOffice;
@property (nonatomic, strong) NSString *titleBarString;
@property (nonatomic, strong) UIImage *imageSeleted;
@end
