//
//  CategoryViewController.m
//  project3
//
//  Spencer de Mars
//  Ainsley Faux
//
//  Defines the CategoryViewController which displays and facilitates user making
//  additional (non "Bet of the Day") bets
//

#import "CategoryViewController.h"

@interface CategoryViewController ()

@property (nonatomic, strong) EventsViewController *eventsViewController;
@property (nonatomic, strong) NSDictionary *categories;

@end

@implementation CategoryViewController

//@synthesize tableView = _tableView;
@synthesize eventsViewController=_eventsViewController;
@synthesize userBetManager=_userBetManager;
@synthesize globalEventManager=_globalEventManager;
@synthesize categories=_categories;

/*
 * (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 *
 * Overwrites method, adding some customizations
 */

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // load list of categories from plist
        self.categories = [[NSDictionary alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"categories" ofType:@"plist"]];

    }
    return self;
}


/*
 * (void) handleContent:(NSArray *)eventsToDisplay
 *
 * Displays day when it is received from server
 */
-(void) handleContent:(NSArray *)eventsToDisplay
{
    // if there are events in this category
    if([eventsToDisplay count]!=0){
        // pass events returned to next controller
        self.eventsViewController.events = eventsToDisplay;
    
        // load view controller when content received
        [self.navigationController pushViewController:self.eventsViewController animated:YES];
    }
    else {
        // create alert to inform user that there are no events
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                        message:@"There aren't any new events in this category. Try again later."
                                                       delegate:self
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil];
        
        // show alert
        [alert show];

    }
}
	
/*
 * (void)viewDidLoad
 *
 * Initiazes page on load
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // allow this controller to receive notifications from globalEventManager
    self.globalEventManager.delegate = self;
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
    return [self.categories count];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // set text of cell to be plist value
    cell.textLabel.text = [[self.categories allValues] objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


/*
 * (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 *
 * Handles user selecting a cell in the table view (choosing a category)
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // allocate new EventsViewController
    self.eventsViewController = [[EventsViewController alloc] initWithNibName:@"EventsViewController"                                                                                           bundle:nil];
    
    
    // pass category name and allow eventsViewController to interface with userBetManager 
    self.eventsViewController.categoryName=[[self.categories allValues] objectAtIndex:indexPath.row];
    self.eventsViewController.userBetManager=self.userBetManager;
    
    // fetch events for category
    [self.globalEventManager eventsForCategory:[[self.categories allValues] objectAtIndex:indexPath.row] WithDelegate:self];
    
}

@end
