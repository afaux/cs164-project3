//
//  EventsViewController.m
//  project3
//
//  Spencer de Mars
//  Ainsley Faux
//
//  Defines the EventsViewController object, which displays additional bets within a category
//

#import "EventsViewController.h"
#import "EventViewController.h"

@interface EventsViewController ()

@end

@implementation EventsViewController

@synthesize categoryName=_categoryName;
@synthesize events=_event;
@synthesize userBetManager=_userBetManager;


/*
 * (void)viewDidLoad
 *
 * Initiazes page on load
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // upate nagivation bar title
    self.navigationItem.title = self.categoryName;
    
}

/*
 * (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 *
 * Only support portrait orientation
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation = UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

/*
 * (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 * 
 * Returns the number of sections in the TableView
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}



/*
 * (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 * 
 * Returns the number of rows in each TableView section 
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.events count];
}


/*
 * (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)
 * 
 * Allocates and displays TableViewCells for each event in a category 
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // set text of cell to be plist key
    cell.textLabel.text = [[self.events objectAtIndex:indexPath.row] title];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

/*
 * (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 *
 * Handles user selecting a cell in the table view (choosing an event to bet on)
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // allocate a new EventViewController
    EventViewController *eventViewController = [[EventViewController alloc] initWithNibName:@"EventViewController"                                                                                           bundle:nil];
   
    // pass event and allow view to interact with core data
    eventViewController.event = [self.events objectAtIndex:indexPath.row];
    eventViewController.userBetManager=self.userBetManager;
    
    // load new view
    [self.navigationController pushViewController:eventViewController animated:YES];
}


@end
