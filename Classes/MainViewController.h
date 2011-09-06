//
//  MainViewController.h
//  RWC 
//
//  Created by Anil Can Baykal on 8/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"


@interface MainViewController : UIViewController<UITableViewDelegate, UITableViewDelegate> {
    
    IBOutlet UITableView * poolTableA; 
    IBOutlet UITableView * poolTableB; 
    IBOutlet UITableView * poolTableC; 
    IBOutlet UITableView * poolTableD; 
	
    SimpleDBSelectRequest * selectRequest;
    SdbRequestDelegate		* sdbDelegate; 

}

@end
