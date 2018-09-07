//
//  MainViewController.m
//  project3
//
//  Spencer de Mars
//  Ainsley Faux
//
//  Defines the MainViewController which displays and handles the "Bet of the Day".
//

#import "MainViewController.h"
#import "GlobalEventManager.h"
#import "EventViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) Event *dailyEvent;
@property (nonatomic, strong) NSArray *updates;

@end

@implementation MainViewController 

// public properties (UI elements)
@synthesize pointsLabel=_pointsLabel;
@synthesize notificationLabel=_notificationLabel;
@synthesize betOfTheDayButton=_betOfTheDayButton;
@synthesize updatesTableView=_updatesTableView;

@synthesize eventViewController=_eventViewController;
@synthesize userBetManager=_userBetManager;
@synthesize globalEventManager = _globalEventManager;
@synthesize dailyEvent=_dailyEvent;
@synthesize updates=_updates;


/*
 * (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 *
 * Overwrites method, adding some customizations
 */

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


-(void) handleContent:(NSArray *)eventsToDisplay
{
    if([eventsToDisplay count]){
        // only one object should be returned and this should be the "Bet of the Day"
         self.eventViewController.event=[eventsToDisplay objectAtIndex:0];
        
        // load view controller when content received
        [self.navigationController pushViewController:self.eventViewController animated:YES];
    }
    else {
        // create alert to inform user that there are no events
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                        message:@"There isn't a \"Bet of the Day\" for today."
                                                       delegate:self
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil];
        
        // show alert
        [alert show];
    }
}


/*
 * (void)viewBetoftheDay
 *
 * Handles user presssing "Bet of the Day" button
 */

-(IBAction)viewBetOfTheDay
{
    // allocate new EventViewController
    self.eventViewController = [[EventViewController alloc] initWithNibName:@"EventViewController" bundle:nil];
    
    // allow eventViewController to interface with userBetManager
    self.eventViewController.userBetManager=self.userBetManager;
   
    // fetch event of the day
    [self.globalEventManager eventOfTheDayWithDelegate:self];

}

/*
 * (void) displayUpdatedBets:(NSArray *)updatedBets
 *
 * When called by UserBetManager, passes updates to MainViewController
 */

-(void) displayUpdatedBets:(NSArray *)updatedBets
{
    self.updates = updatedBets;
    [self.updatesTableView reloadData];
    
    if([self.updates count]!=0){   
        self.updatesTableView.hidden = NO;
        self.notificationLabel.hidden = YES;
    }
    
[self refresh];
    
}

/*
 * (void)viewDidLoad
 *
 * Initiazes page on load
 */

- (void)viewDidLoad
{    
    // allow this controller to receive notifications from globalEventManager
    self.globalEventManager.delegate = self;
    
    // fetch updates to user bets
    //self.updates = [NSArray arrayWithObjects:@"A",@"B",@"C", nil];
    
    // show table view if there are updates
    if([self.updates count] > 0)
    {
        self.updatesTableView.hidden = NO;
        self.notificationLabel.hidden = YES;
    }    
    
    self.pointsLabel.text = [NSString stringWithFormat:@"Available Points: %d",[self.userBetManager.userData.points
                                                              intValue]];
    
    [self.userBetManager updateBetsWithDelegate:self];
}

- (void)refresh
{
    self.pointsLabel.text = [NSString stringWithFormat:@"Available Points: %d",[self.userBetManager.userData.points
                                                              intValue]];
}

/*
 * (void) viewDidAppear:(BOOL)animated
 *
 * Refreshes the screen when this view appears again
 */
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self refresh];
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

#pragma mark - Table View

/*
 * (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 * 
 * Returns the number of sections in the TableView
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


/*
 * (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 * 
 * Returns the number of rows in each TableView section 
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.updates count];
}


/*
 * (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)
 * 
 * Allocates and displays TableViewCells for each category 
 */


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // retrieve bet object 
    Bet *bet = [self.updates objectAtIndex:indexPath.row];
    NSString *outcome = [NSString string];
    
    // locate outcome 
    if([bet.event.status intValue] == 1)
        outcome = bet.event.outcome1;
    else if([bet.event.status intValue] ==2)
        outcome = bet.event.outcome2;
    
    // determine if bet was won or lost and adjust color accordingly
    if(bet.event.status == bet.predictedOutcome){
        cell.textLabel.textColor = [UIColor colorWithRed:42.0/255
                                                    green:166.0/255 
                                                     blue:40.0/255
                                                    alpha:1.0];
    }
    if(bet.event.status != bet.predictedOutcome){
        cell.textLabel.textColor = [UIColor colorWithRed:1.0
                                                   green:.41 
                                                    blue:.32 
                                                   alpha:1.0];
    }
    // update labels
    cell.textLabel.text = bet.event.title;
    cell.detailTextLabel.text = outcome;
   
    // don't highlight rows when selected
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
