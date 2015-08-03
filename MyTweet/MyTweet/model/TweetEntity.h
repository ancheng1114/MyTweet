//
//  TweetEntity.h
//  MyTweet
//
//  Created by AnCheng on 8/2/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TweetEntity : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * screenname;
@property (nonatomic, retain) NSString * profilethumb;
@property (nonatomic, retain) NSString * datestr;
@property (nonatomic, retain) NSDate * date;

@end
