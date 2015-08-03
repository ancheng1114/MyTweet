//
//  TwitterUser.h
//  MyTweet
//
//  Created by AnCheng on 8/2/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterUser : NSObject

@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) NSString *screenname;
@property (nonatomic ,strong) NSString *profileImageUrl;
@property (nonatomic ,strong) NSString *tagline;
@property (nonatomic ,strong) NSString *location;

@property (nonatomic) int numTweets;
@property (nonatomic) int friendsCount;
@property (nonatomic) int followersCount;

@property (nonatomic ,strong) NSDictionary *userDictionary;

- (void)setDic:(NSDictionary *)userDictionary;

@end
