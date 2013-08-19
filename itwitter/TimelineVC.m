//
//  TimelineVC.m
//  itwitter
//
//  Created by Sriram Varadarajan on 8/18/13.
//  Copyright (c) 2013 Y.CORP.YAHOO.COM\vsriram. All rights reserved.
//

#import "TimelineVC.h"
#import "TweetCell.h"

@interface TimelineVC ()

@property (nonatomic, strong) NSMutableArray *tweets;

- (void)onSignOutButton;
- (void)reload;

@end

@implementation TimelineVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    NSLog(@"%@", @"TimelineVC:initWithStyle called...");

    if (self) {
        self.title = @"Twitter";
        NSLog(@"%@", @"TimelineVC:initWithStyle about to call reload...");
        
        [self reload];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", @"TimelineVC:viewDidLoad called...");

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
    
    UINib *customNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:customNib forCellReuseIdentifier:@"TweetCell"];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Tweet *tweet = self.tweets[indexPath.row];
    
    cell.tweetLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;

    cell.nameLabel.text = tweet.userScreenName;
    
    NSURL *url = [NSURL URLWithString:tweet.userImage ];
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    [cell.userImage setImage:image];

    [cell.tweetLabel setLineBreakMode: NSLineBreakByWordWrapping];
    cell.tweetLabel.numberOfLines = 0;
    
    cell.tweetLabel.text = tweet.text;
    [cell.tweetLabel sizeToFit];

    
    /*
     CGSize s = [tweet.text sizeWithFont:cell.tweetLabel.font
                  constrainedToSize:CGSizeMake(self.view.bounds.size.width - 90,     999)
                      lineBreakMode:NSLineBreakByWordWrapping];
    CGRect labelFrame = cell.tweetLabel.frame;
    labelFrame.size.height = s.height;
    labelFrame.size.width = s.width;
    cell.tweetLabel.frame = labelFrame;
    //[cell.tweetLabel setNeedsDisplay];
     */
    

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Tweet *tweet = self.tweets[indexPath.row];
    
    CGSize size = [tweet.text sizeWithFont:[UIFont systemFontOfSize:17]
                  constrainedToSize:CGSizeMake(self.view.bounds.size.width - 60,     CGFLOAT_MAX)  // - 40 For cell padding
                      lineBreakMode:NSLineBreakByWordWrapping];
    

    return size.height+20;
 
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

#pragma mark - Private methods

- (void)onSignOutButton {
    [User setCurrentUser:nil];
}

- (void)reload {
    NSLog(@"%@", @"TimelineVC:reload called...");
    [[TwitterClient instance] homeTimelineWithCount:26 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        self.tweets = [Tweet tweetsWithArray:response];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
        NSLog(@"%@", @"some error");
    }];
}

@end
