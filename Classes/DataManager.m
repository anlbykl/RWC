//
//  DataManager.m
//  RWC 
//
//  Created by Anil Can Baykal on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"
#import "RWC_AppDelegate.h"

NSString * const poolsFinishedNotification 	= @"metin";
NSString * const gamesFinishedNotification 	= @"ali";  
NSString * const finalsFinishedNotification = @"feyyaz";  

NSString * const poolsReceivedNotification = @"recep";
NSString * const gamesReceivedNotification = @"riza";

@implementation DataManager

static DataManager * sharedInstance; 
static RWC_AppDelegate  * appDelegate; 

+(void) initialize {
     
    if ( sharedInstance == nil)  {
        sharedInstance = [DataManager new]; 
        appDelegate = (RWC_AppDelegate  *)[[UIApplication sharedApplication] delegate]; 
    }
}

+(DataManager*)manager{
    
    return sharedInstance; 
}

+(void)updateInBackground{
    
    [sharedInstance performSelectorInBackground:@selector(update) withObject:nil]; 
    //[sharedInstance update]; 
}

- (id)init
{
    self = [super init];
    if (self) {
        
        poolCache = [[NSCache alloc] init]; 
        gameCache = [[NSCache alloc] init]; 
        
        poolsDelegate = [[SdbRequestDelegate alloc] init]; 
        poolsDelegate.finishedNotification = poolsFinishedNotification;         
    	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(poolsReceived) 
													name:poolsFinishedNotification
                                                   object:nil];
		
        gamesDelegate= [[SdbRequestDelegate alloc] init]; 
        gamesDelegate.finishedNotification = gamesFinishedNotification;         
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gamesReceived) 
                                                     name:gamesFinishedNotification
                                                   object:nil];
        
        
    }
    
    return self;
}


-(void) update{
	
    @try {
        
        /*
        NSString * selectPoolsExpression = @"select * from `Pools`";
        SimpleDBSelectRequest * selectPoolsRequest = [[SimpleDBSelectRequest alloc] initWithSelectExpression:selectPoolsExpression];
        [selectPoolsRequest setDelegate:poolsDelegate];
        selectPoolsRequest.consistentRead = YES;
        
        [[Constants sdb] select:selectPoolsRequest];
        */
	
        NSString * selectGamesExpression = @"select * from `Games`";
        SimpleDBSelectRequest * selectGamesRequest = [[SimpleDBSelectRequest alloc] initWithSelectExpression:selectGamesExpression];
        [selectGamesRequest setDelegate:gamesDelegate];
        selectGamesRequest.consistentRead = YES;
        
        [[Constants sdb] select:selectGamesRequest];		
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    } 
}

-(void)poolsReceived {
    
    @try {
                
        [appDelegate deleteAll:@"Team"]; 
                
        SimpleDBSelectResponse *selectResponse = (SimpleDBSelectResponse*)[poolsDelegate response]; 
        
       
        NSMutableArray * items = [NSMutableArray arrayWithCapacity:[selectResponse.items count]];
       
       
        for (SimpleDBItem *item in selectResponse.items) {
 
            Team * t = (Team*)[NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:appDelegate.managedObjectContext];            
            t.name = item.name; 
            
            for ( SimpleDBAttribute *attr  in item.attributes) {
                
                if ( [attr.name isEqualToString:@"pool"]){
                    NSLog(@"%@", attr.value);
                    t.pool = attr.value;
                    
                } else if ([attr.name isEqualToString:@"standing"]) {
                 	                    
					NSArray * standing = [attr.value componentsSeparatedByString:@"/"]; 
                                        
                    t.played 	= _NSNumberFromString([standing objectAtIndex:Played]); 
                    t.won		= _NSNumberFromString([standing objectAtIndex:Won]);
                    t.lost		= _NSNumberFromString([standing objectAtIndex:Lost]);
                    
                    t.pointsFor		= _NSNumberFromString([standing objectAtIndex:PointsFor]);
                    t.pointsAgainst	= _NSNumberFromString([standing objectAtIndex:PointsAgainst]);                
                    t.triesFor 		= _NSNumberFromString([standing objectAtIndex:TriesFor]);
                    t.triesAgainst	= _NSNumberFromString([standing objectAtIndex:TriesAgainst]);
                    t.bonusPoints	= _NSNumberFromString([standing objectAtIndex:BonusPoints]);
                    
                    t.points		= _NSNumberFromString([standing objectAtIndex:Points]);
                    t.poolRank		= _NSNumberFromString([standing objectAtIndex:PoolRank]);
                                        
                }
            }
            
            [items addObject:t];                         
        }
        
        
    }
    @catch (AmazonServiceException *_exception) {
        NSLog(@"Exception = %@", _exception);
        return;
    }
    
    [appDelegate save]; 
    [poolCache removeAllObjects]; 
    
 	[[NSNotificationCenter defaultCenter] postNotificationName:poolsReceivedNotification object:nil];
}

-(void)gamesReceived {
    
    @try {
        
        [appDelegate deleteAll:@"Game"]; 
        
        SimpleDBSelectResponse *selectResponse = (SimpleDBSelectResponse*)[gamesDelegate response];             	
        NSMutableArray * games = [NSMutableArray arrayWithCapacity:[selectResponse.items count]];
    
        NSDateFormatter * megatron = [[[NSDateFormatter alloc] init] autorelease];
        [megatron setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:60*60*12]]; 
        [megatron setDateFormat:@"dd/MM - HH:mm"]; 
        
        NSCalendar * greg = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease]; 
        
        for (SimpleDBItem *item in selectResponse.items) {
            
            Game * g = (Game*)[NSEntityDescription insertNewObjectForEntityForName:@"Game" 
                                                            inManagedObjectContext:appDelegate.managedObjectContext];                         
	
            NSArray * ins = [item.name componentsSeparatedByString:@"-"]; 
            
            g.pool = [ins objectAtIndex:0]; 
            g.home = [ins objectAtIndex:1]; 
            g.away = [ins objectAtIndex:2]; 
                       
            for ( SimpleDBAttribute * attr in item.attributes) {
                
                if ( [attr.name isEqualToString:@"date"]) {

                	NSDateComponents* comp = [greg components:(NSHourCalendarUnit|NSMinuteCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) 
                                                     fromDate:[megatron dateFromString:attr.value]]; 
	
                    comp.year = 2011; 
                    [greg setLocale:[NSLocale currentLocale]]; 
                    
                    g.date = [greg dateFromComponents:comp]; 
                
                } else if ( [attr.name isEqualToString:@"venue"]) {
                	g.venue = attr.value;                 	
                
                }else if ( [attr.name isEqualToString:@"score"]) {                	
                	g.score = attr.value; 
                }
        	}

            [games addObject:g];             
        }
        
    }@catch(AmazonServiceException *_exception) {
        
        NSLog(@"amazon exception for games = %@", _exception);        
        return; 
    }
     
    [appDelegate save]; 
    [gameCache removeAllObjects]; 
    
 	[[NSNotificationCenter defaultCenter] postNotificationName:gamesReceivedNotification object:nil];
            
}


-(void)getTeams{
    
    
}

-(NSArray*) getPool:(NSString*)name{
    
	NSArray * pool = [poolCache objectForKey:name]; 
    
    if (pool == nil){
                
        pool = [self fetchPool:name]; 
        [poolCache setObject:pool forKey:name]; 
        
    }
        
    return pool; 
    
}

-(NSArray*) fetchPool:(NSString*)name{
    

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Team"
	inManagedObjectContext:appDelegate.managedObjectContext];
	[fetchRequest setEntity:entity];

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pool like %@",name];
	NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"poolRank" ascending:YES];
    
	[fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sort, nil]]; 

	NSError *error = nil;
	NSArray *fetchedObjects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
	[fetchRequest release];
    
    return fetchedObjects; 
}

@end
