//
//  Tweet.h
//  MyTweet
//
//  Created by AnCheng on 8/2/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwitterUser.h"

@interface Tweet : NSObject

@property (nonatomic) int id;
@property (nonatomic ,strong) NSString *text;
@property (nonatomic ,strong) NSString *createdAtString;
@property (nonatomic ,strong) NSDate *createdAt;

@property (nonatomic) int favoriteCount;
@property (nonatomic) BOOL favorited;
@property (nonatomic) int retweetCount;
@property (nonatomic) BOOL retweeted;

@property (nonatomic ,strong) TwitterUser *user;
@property (nonatomic ,strong) Tweet *retweetSource;
@property (nonatomic ,strong) Tweet *retweet;

@property (nonatomic ,strong) NSDictionary *tweetDictionary;

- (void)setDic:(NSDictionary *)tweetDictionary;
- (void)setDic1:(NSDictionary *)tweetDictionary;

@end
