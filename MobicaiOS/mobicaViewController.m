//
//  mobicaViewController.m
//  MobicaiOS
//
//  Created by masy on 7/8/13.
//  Copyright (c) 2013 masy. All rights reserved.
//

#import "mobicaViewController.h"
#import "InfoViewController.h"

@interface mobicaViewController ()

@end

@implementation mobicaViewController
{
    NSArray *mobicaOfficeArray;
    NSArray *mobicaImageArray;
    NSString *selectedOffice;
    UIImage *seletedImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    mobicaOfficeArray = [NSArray arrayWithObjects:@"LODZ", @"WARSAW", @"BYDGOSZCZ", @"SZCZECIN", nil];
    mobicaImageArray = [NSArray arrayWithObjects:@"lodz.png", @"warsaw.png", @"bydgoszcz.png", @"szczecin.png", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mobicaOfficeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [mobicaOfficeArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[mobicaImageArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UIAlertView *messageAlert = [[UIAlertView alloc]
    //                             initWithTitle:@"Row Selected" message:@"You've selected a row" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    selectedOffice = [mobicaOfficeArray objectAtIndex:indexPath.row];
    seletedImage = [UIImage imageNamed:[mobicaImageArray objectAtIndex:indexPath.row]];
    NSLog(@"Selected office %@:", selectedOffice);
    
    // Display Alert Message
    //[messageAlert show];
    
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if(selectedOffice.length != 0)
    {
        return YES;
    }
    else
    {
        UIAlertView *alertMess = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select office" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertMess show];
        return NO;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"infoMobicaSeque"] ) {
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        InfoViewController *destViewController = segue.destinationViewController;
        destViewController.titleBarString = selectedOffice;
        destViewController.imageSeleted = seletedImage;
    }
}


@end
