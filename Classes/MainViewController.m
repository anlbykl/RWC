    //
//  MainViewController.m
//  RWC 
//
//  Created by Anil Can Baykal on 8/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"


@implementation MainViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor redColor]; 
      
  	[[DataManager manager] update]; 
	
  	[[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(reloadTables) 
                                                 name:poolsReceivedNotification 
                                               object:nil]; 
    
}

-(void)reloadTables{
    
    [poolTableA reloadData]; 
    [poolTableB reloadData]; 
    [poolTableC reloadData]; 
    [poolTableD reloadData]; 
}

-(NSArray*) teamsForTable:(UITableView*)table{
    
    if ( [table isEqual:poolTableA])
        return [[DataManager manager] getPool:@"A"]; 
    
    if ( [table isEqual:poolTableB])
        return [[DataManager manager] getPool:@"B"]; 

    if ( [table isEqual:poolTableC])
        return [[DataManager manager] getPool:@"C"]; 

    if ( [table isEqual:poolTableD])
        return [[DataManager manager] getPool:@"D"]; 
    
    return nil; 
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {    
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

//tableview stuff
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{    
	return [[self teamsForTable:tableView] count]; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DreamTheater";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
    }

	Team * t = [[self teamsForTable:tableView] objectAtIndex:indexPath.row];	
    
    cell.textLabel.text = t.name; 
    cell.detailTextLabel.text = [t.points stringValue]; 
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)dealloc {
    [super dealloc];
}


@end
