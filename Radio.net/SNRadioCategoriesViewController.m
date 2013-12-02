//
//  SNRadioCategoriesViewController.m
//  Radio.net
//
//  Created by Noda Shimpei on 2013/05/06.
//  Copyright (c) 2013年 Noda Shimpei. All rights reserved.
//

#import "SNRadioCategoriesViewController.h"
#import "SNRadioStationsViewController.h"
#import "SNRadioCategory.h"

#import <RaptureXML/RXMLElement.h>
#import <MKNetworkKit/MKNetworkKit.h>

@interface SNRadioCategoriesViewController () {
    NSMutableArray *_categories;
}

@end

@implementation SNRadioCategoriesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableArray *)categories {
    if (_categories == nil)
        _categories = [NSMutableArray array];
    return _categories;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
        
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"pri.kts-af.net" apiPath:@"xml" customHeaderFields:nil];
    MKNetworkOperation *operation = [engine operationWithPath:@"index.xml" params:@{ @"sid": @"09A05772824906D82E3679D21CB1158B", @"tuning_id": [NSNumber numberWithInt:1] } httpMethod:@"GET"];
    NSLog(@"[GET] -- URL: %@", [operation url]);
    [operation setShouldNotCacheResponse:YES];
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        RXMLElement *rootXMLElement = [RXMLElement elementFromXMLData:[completedOperation responseData]];
        [rootXMLElement iterate:@"results.menu_record" usingBlock:^(RXMLElement *categoryXMLElement) {
            NSLog(@"[Category] -- Name: %@, ID: %@", [categoryXMLElement child:@"name"], [categoryXMLElement child:@"menu_id"]);
            SNRadioCategory *radioCategory = [[SNRadioCategory alloc] initWithCid:[categoryXMLElement child:@"menu_id"].text Name:[categoryXMLElement child:@"name"].text];
            [[self categories] addObject:radioCategory];
            [[self tableView] reloadData];
        }];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
    }];
    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self categories] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RadioCategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    SNRadioCategory *radioCategory = [[self categories] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[radioCategory name]];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SNRadioCategory *radioCategory = [[self categories] objectAtIndex:[indexPath row]];
    SNRadioStationsViewController *radioStationsViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"SNRadioStationsViewController"];
    [radioStationsViewController setRadioCategory:radioCategory];
    [[self navigationController] pushViewController:radioStationsViewController animated:YES];
}

@end
