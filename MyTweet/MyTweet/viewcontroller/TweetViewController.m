//
//  TweetViewController.m
//  MyTweet
//
//  Created by AnCheng on 8/2/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import "TweetViewController.h"

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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
  
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
            AppDelegate * delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
            params[@"count"] = [NSString stringWithFormat:@"%d",30];
            params[@"screen_name"] =  delegate.curAccount.username;
            
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url                                      parameters:params];
            [request setAccount:delegate.curAccount];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSURLRequest *request1 = request.preparedURLRequest;
                AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request1];
                op.responseSerializer = [AFJSONResponseSerializer serializer];
                [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    [SVProgressHUD dismiss];
                    NSLog(@"JSON: %@", responseObject);
                    
                    for (NSDictionary *dic in responseObject)
                    {
                        Tweet *tweet = [Tweet new];
                        [tweet setDic:dic];
                        [_tweetArr addObject:tweet];
                    }
                    
                    [SVProgressHUD dismiss];
                    [_tweetTableView reloadData];

                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [SVProgressHUD dismiss];
                    NSLog(@"Error: %@", error);
                }];
                
                [op start];
                
            });
            
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
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                
                NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/search.json"];
                AppDelegate * delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
                NSDictionary *params = @{@"count":@(20).stringValue, @"q":textField.text };
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url                                      parameters:params];
                [request setAccount:delegate.curAccount];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSURLRequest *request1 = request.preparedURLRequest;
                    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request1];
                    op.responseSerializer = [AFJSONResponseSerializer serializer];
                    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        NSLog(@"JSON: %@", responseObject);
                        
                        [_tweetArr removeAllObjects];
                        for (NSDictionary *dic in responseObject)
                        {
                            Tweet *tweet = [Tweet new];
                            [tweet setDic1:dic];
                            [_tweetArr addObject:tweet];
                        }
                        
                        [SVProgressHUD dismiss];
                        [_tweetTableView reloadData];
                        
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [SVProgressHUD dismiss];
                        NSLog(@"Error: %@", error);
                    }];
                    
                    [op start];
                    
                });
                
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
