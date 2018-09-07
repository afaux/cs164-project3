//
//  HistoryViewController.m
//  project3
//
//  Spencer de Mars
//  Ainsley Faux
//
//  Defines the EventsViewController object, which displays additional bets within a category
//

#import "HistoryViewController.h"
#import "GlobalEventManager.h"
#import "StatsViewController.h"
#import "UserBetViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

@synthesize bets=_bets;
@synthesize userBetManager=_userBetManager;

/*
 * (void)viewDidLoad
 *
 * Initiazes page on load
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // fetch bet history from userBetManager
    self.bets = [self.userBetManager betHistory];
    
    // create a button to access stats page
    UIBarButtonItem *statsButton = [[UIBarButtonItem alloc] initWithTitle:@"Stats"style:  UIBarButtonItemStylePlain target:self action:@selector(viewStats)];
    
    self.navigationItem.rightBarButtonItem = statsButton;
}

/*
 * (void)viewDidAppear:(BOOL)animated
 *
 * Refresh information when view is reloaded
 */
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // fetch bet history from userBetManager
    self.bets = [self.userBetManager betHistory];

    // refresh data in table view
    [self.tableView reloadData];
}

/*
 * (void)viewStats
 *
 * Switches to stats view 
 */

-(void)viewStats
{
    // create new view controller
    StatsViewController* statsViewController = [[StatsViewController alloc] initWithNibName:@"StatsViewController" bundle:nil];
    
    // allow stats view controller to interface with userBetManager
    statsViewController.userBetManager = self.userBetManager;
    
    // display view controller
    [self.navigationController pushViewController:statsViewController animated:YES];

}


/*
 * (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 *
 * Only support portrait orientation
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return [self.bets count];
}

/*
 * (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)
 * 
 * Allocates and displays TableViewCells for each past bet 
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    Bet *bet = [self.bets objectAtIndex:indexPath.row];
    
    int status = [bet.event.status intValue];
    int outcome = [bet.predictedOutcome intValue];
    // determine if bet was won or lost and adjust color accordingly
    if(status == 0){
        cell.textLabel.textColor = [UIColor blackColor];
    }
    else if(status == outcome){
        cell.textLabel.textColor = [UIColor colorWithRed:42.0/255
                                                   green:166.0/255 
                                                    blue:40.0/255
                                                   alpha:1.0];
    }
    else if(status != outcome){
        cell.textLabel.textColor = [UIColor colorWithRed:1.0
                                                   green:.41 
                                                    blue:.32 
                                                   alpha:1.0];
    }

    
    // update cell text
    cell.textLabel.text = bet.event.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;

}


#pragma mark - Table view delegate

/*
 * (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 *
 * Handles user selecting a cell in the table view (choosing a past bet to view)
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // allocate a new bet
    UserBetViewController *userBetViewController = [[UserBetViewController alloc] initWithNibName:@"UserBetViewController" bundle:nil];
    
    // pass bet to userBetViewController
    userBetViewController.bet = [self.bets objectAtIndex:indexPath.row];
    
    // load new view
    [self.navigationController pushViewController:userBetViewController animated:YES];
     
}

@end
