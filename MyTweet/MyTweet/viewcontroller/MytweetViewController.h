//
//  MytweetViewController.h
//  MyTweet
//
//  Created by AnCheng on 8/2/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MytweetViewController : UIViewController <UITableViewDataSource ,UITableViewDelegate ,NSFetchedResultsControllerDelegate>

@property (nonatomic ,assign) IBOutlet UITableView *mytweetTableView;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
