//
//  SNRadioStationsViewController.m
//  Radio.net
//
//  Created by Noda Shimpei on 2013/05/12.
//  Copyright (c) 2013年 Noda Shimpei. All rights reserved.
//

#import "SNRadioStationsViewController.h"
#import "SNRadioCategory.h"
#import "SNRadioStation.h"
#import "SNRadioPlayerViewController.h"

#import <RaptureXML/RXMLElement.h>
#import <MKNetworkKit/MKNetworkKit.h>

@interface SNRadioStationsViewController () {
    SNRadioCategory *_radioCategory;
    NSMutableArray *_stations;
}

@end

@implementation SNRadioStationsViewController

@synthesize radioCategory = _radioCategory;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSMutableArray *)stations {
    if (_stations == nil)
        _stations = [NSMutableArray array];
    return _stations;
}

- (void)setRadioCategory:(SNRadioCategory *)radioCategory {
    [self loadRadioStations:radioCategory];
    _radioCategory = radioCategory;
}

- (void)loadRadioStations:(SNRadioCategory *)radioCategory {
    if (radioCategory == nil || _radioCategory == radioCategory)
        return;
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"pri.kts-af.net" apiPath:@"xml" customHeaderFields:nil];
    MKNetworkOperation *operation = [engine operationWithPath:@"index.xml" params:@{ @"sid": @"09A05772824906D82E3679D21CB1158B", @"tuning_id": [radioCategory cid] } httpMethod:@"GET"];
    NSLog(@"[GET] -- URL: %@", [operation url]);
    [operation setShouldNotCacheResponse:YES];
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        RXMLElement *rootXMLElement = [RXMLElement elementFromXMLData:[completedOperation responseData]];
        [rootXMLElement iterate:@"results.station_record" usingBlock:^(RXMLElement *stationXMLElement) {
            NSLog(@"[Station] -- Name: %@, URL: %@", [stationXMLElement child:@"station"], [stationXMLElement child:@"station_url_record.url"]);
            SNRadioStation *radioStation = [[SNRadioStation alloc] initWithName:[stationXMLElement child:@"station"].text Descript:[stationXMLElement child:@"description"].text URL:[NSURL URLWithString:[stationXMLElement child:@"station_url_record.url"].text]];
            [[self stations] addObject:radioStation];
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
    return [[self stations] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RadioStationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    SNRadioStation *radioStation = [[self stations] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[radioStation name]];
    [[cell detailTextLabel] setText:[radioStation descript]];
    
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
    SNRadioStation *radioStation = [[self stations] objectAtIndex:[indexPath row]];
    SNRadioPlayerViewController *radioPlayerViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"SNRadioPlayerViewController"];
    [radioPlayerViewController setRadioStation:radioStation];
    [radioPlayerViewController setHidesBottomBarWhenPushed:YES];
    [[self navigationController] pushViewController:radioPlayerViewController animated:YES];
}

@end
