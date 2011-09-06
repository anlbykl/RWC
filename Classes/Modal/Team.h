//
//  Team.h
//  RWC 
//
//  Created by Anil Can Baykal on 8/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Team : NSManagedObject

@property (nonatomic, retain) NSNumber * points;
@property (nonatomic, retain) NSNumber * played;
@property (nonatomic, retain) NSNumber * lost;
@property (nonatomic, retain) NSString * pool;
@property (nonatomic, retain) NSNumber * triesFor;
@property (nonatomic, retain) NSNumber * pointsAgainst;
@property (nonatomic, retain) NSNumber * pointsFor;
@property (nonatomic, retain) NSNumber * triesAgainst;
@property (nonatomic, retain) NSNumber * bonusPoints;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * won;
@property (nonatomic, retain) NSNumber * poolRank;

@end
