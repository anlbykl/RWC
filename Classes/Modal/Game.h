//
//  Game.h
//  RWC 
//
//  Created by Anil Can Baykal on 8/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Game : NSManagedObject

@property (nonatomic, retain) NSString * away;
@property (nonatomic, retain) NSString * score;
@property (nonatomic, retain) NSString * venue;
@property (nonatomic, retain) NSString * pool;
@property (nonatomic, retain) NSString * home;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * url;

@end
