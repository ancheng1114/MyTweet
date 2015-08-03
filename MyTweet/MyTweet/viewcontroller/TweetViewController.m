//
//  TweetViewController.m
//  MyTweet
//
//  Created by AnCheng on 8/2/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "TweetViewController.h"
#import "FHSTwitterEngine.h"

@interface TweetViewController ()

@end

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tweetTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tweetArr = [NSMutableArray new];
    [self logTimeline];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)logTimeline
{
    [_tweetArr removeAllObjects];
    
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeClear];
    [[FHSTwitterEngine sharedEngine]loadAccessToken];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            
            NSArray * timeLine = [[FHSTwitterEngine sharedEngine] getHomeTimelineSinceID:nil count:30];
            for (NSDictionary *dic in timeLine)
            {
                Tweet *tweet = [Tweet new];
                [tweet setDic:dic];
                [_tweetArr addObject:tweet];
            }
            
            [SVProgressHUD dismiss];
            [_tweetTableView reloadData];
            
        }
    });
    
}

- (IBAction)onRefresh:(id)sender
{
    [self logTimeline];
}

- (IBAction)onSearch:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Search Tweet" message:@"Please type keyword for search" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:nil];
    
    [alert addAction: [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = alert.textFields[0];
        
        [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeClear];
        
        [[FHSTwitterEngine sharedEngine]loadAccessToken];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                
                [_tweetArr removeAllObjects];
                
                NSArray * timeLine = [[FHSTwitterEngine sharedEngine] searchUsersWithQuery:textField.text andCount:20];
                for (NSDictionary *dic in timeLine)
                {
                    Tweet *tweet = [Tweet new];
                    [tweet setDic1:dic];
                    [_tweetArr addObject:tweet];
                }
                
                [SVProgressHUD dismiss];
                [_tweetTableView reloadData];
            }
        });

    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"Cancel pressed");
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource ,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tweetArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tweetCell" forIndexPath:indexPath];
    Tweet *tweet = [_tweetArr objectAtIndex:indexPath.row];
    [cell setTweet:tweet];
    cell.celldelegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    
}

#pragma mark - TweetTableViewCellDelegate
- (void)saveTweet:(TweetTableViewCell *)cell
{
    NSLog(@"Saved Tweet");
    NSIndexPath *indexPath = [_tweetTableView indexPathForCell:cell];
    Tweet *tweet = [_tweetArr objectAtIndex:indexPath.row];
    [[CoredataManager sharedManager] addTweet:tweet];
    
}

@end
