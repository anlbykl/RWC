//
//  DataManager.h
//  RWC 
//
//  Created by Anil Can Baykal on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "SdbRequestDelegate.h"

#import "Team.h"
#import "Game.h"

extern NSString * const poolsFinishedNotification; 
extern NSString * const gamesFinishedNotification; 
extern NSString * const finalsFinishedNotification; 

extern NSString * const poolsReceivedNotification; 
extern NSString * const gamesReceivedNotification; 




//P=Played; W=Won; D=Draw; L=Lost; PF=Points For; PA=Points Against; TF=Tries For; TA=Tries Against; BP=Bonus Points; PTS=Points
#define Played			0
#define Won				1
#define Draw			2
#define Lost			3
#define PointsFor		4
#define	PointsAgainst	5
#define TriesFor		6
#define TriesAgainst	7
#define BonusPoints		8
#define Points			9
#define PoolRank		10


#define _NSNumberFromString(x) [NSNumber numberWithInt:[x intValue]]

@interface DataManager : NSObject {
    
    SdbRequestDelegate * poolsDelegate; 
    SdbRequestDelegate * gamesDelegate; 
    SdbRequestDelegate * finalsDelegate; 
    
    NSCache * poolCache;
    NSCache * gameCache; 
}


+(DataManager*) manager;
+(void) updateInBackground; 

-(void) update;
-(NSArray*) getPool:(NSString*)name;
-(NSArray*) fetchPool:(NSString*)name;



@end
