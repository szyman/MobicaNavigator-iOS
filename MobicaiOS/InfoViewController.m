//
//  InfoViewController.m
//  MobicaiOS
//
//  Created by masy on 7/8/13.
//  Copyright (c) 2013 masy. All rights reserved.
//

#import "InfoViewController.h"
#import "MapViewController.h"

@interface InfoViewController ()

@end


@implementation InfoViewController
{
    NSString *officeName;
}

@synthesize titleBar;
@synthesize titleBarString;
@synthesize imageOffice;
@synthesize imageSeleted;

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
	// Do any additional setup after loading the view.
    officeName = titleBarString;
    titleBarString = [titleBarString stringByAppendingString:@" info"];
    titleBar.title = titleBarString;
    imageOffice.image = imageSeleted;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"mapMobicaSeque"] ) {
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MapViewController *destViewController = segue.destinationViewController;
        destViewController.selectedOfficeString = officeName;
    }
}

@end
