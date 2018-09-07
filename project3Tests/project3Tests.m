//
//  project3Tests.m
//  project3Tests
//
//  Created by Spencer de Mars, Ainsley Faux
//
//  These run the application and logic tests for project3.  We chose to integrate the application
//  and logic tests because the logic / models depend heavily on Core Data which requires the
//  application to be running in order to get the persistent store coordinator, etc. The strange
//  names are just to guarantee the tests run in the desired order.
//
//  NOTE: These tests are designed to run with no previous information in core data, so make sure
//  to delete the project3 app from the iphone simulator before running the tests
//
#import "project3Tests.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "EventViewController.h"


@interface project3Tests ()

@property (readwrite, nonatomic, weak) AppDelegate *appDelegate;
@property (readwrite, nonatomic, weak) MainViewController *mainViewController;
@property (readwrite, nonatomic, weak) EventViewController *eventViewController;
@property (readwrite, nonatomic, weak) UserBetManager *userBetManager;

@end
@implementation project3Tests

@synthesize appDelegate = _appDelegate;
@synthesize mainViewController = _mainViewController;
@synthesize eventViewController = _eventViewController;
@synthesize userBetManager = _userBetManager;

- (void)setUp
{
    [super setUp];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.mainViewController = self.appDelegate.mainViewController;
    self.eventViewController = (EventViewController *) self.mainViewController.eventViewController;
    self.userBetManager = self.appDelegate.userBetManager;
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

/*
 * (void) testCoreDataLoad
 *
 * tests to see if the user bet manager and user data actually loaded
 */

- (void)atestCoreDataLoad
{
    XCTAssertNotNil(self.mainViewController,@"Main view controller did not load");
    XCTAssertNotNil(self.userBetManager,@"userBetManager did not load");
    XCTAssertNotNil(self.userBetManager.userData, @"user Data did not load");
}

/*
 * (void) testPlaceBet
 *
 * Tests to see if a bet is actually placed when we call the method
 */

- (void)btestPickOutcome 
{
    // we need a dummy event to test
    Event *dummyEvent = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.userBetManager.managedObjectContext];
    
    [dummyEvent setOdds1:[NSNumber numberWithFloat:1.0]];
    [dummyEvent setOdds2:[NSNumber numberWithFloat:1.0]];
    [dummyEvent setMaxWager:[NSNumber numberWithFloat:0.5]];
    [dummyEvent setIdNumber:[NSNumber numberWithInt:100]];
    [dummyEvent setStatus:[NSNumber numberWithInt:0]];
    [dummyEvent setOutcome1:@"outcome1"];
    [dummyEvent setOutcome2:@"outcome2"];
    [dummyEvent setDetails:@"details"];
    [dummyEvent setTitle:@"title"];
    [dummyEvent setCategory:@"category"];
    
    NSMutableArray *dummyArray = [[NSMutableArray alloc] init];
    [dummyArray addObject:dummyEvent];
    
    [self.userBetManager placeBetOnEvent:dummyEvent WithOutcome:[NSNumber numberWithInt:1] AndWager:[NSNumber numberWithInt:100]];
    
    // "press" view bet of the day
    [self.mainViewController viewBetOfTheDay];
    
    // fake content arriving
    [self.mainViewController handleContent:dummyArray];
    
    // retrieve our bets
    NSArray *betArray = [self.userBetManager outstandingBets];
    XCTAssertNotNil(betArray, @"Bet array is nil");
    
    XCTAssertTrue([betArray count] > 0, @"Bet is not being logged correctly");
    
}

/*
 * (void) testPayOutBet
 *
 * See if when the status for an event changes the Bet actually gets paid out
 */
- (void)ctestPayOutBet
{
    // our old bet will still be in there so let's make it change status
    // we need our dummy event to be decided now
    Event *dummyEvent = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.userBetManager.managedObjectContext];
    
    [dummyEvent setOdds1:[NSNumber numberWithFloat:1.0]];
    [dummyEvent setOdds2:[NSNumber numberWithFloat:1.0]];
    [dummyEvent setMaxWager:[NSNumber numberWithFloat:0.5]];
    [dummyEvent setIdNumber:[NSNumber numberWithInt:100]];
    [dummyEvent setStatus:[NSNumber numberWithInt:1]];
    [dummyEvent setOutcome1:@"outcome1"];
    [dummyEvent setOutcome2:@"outcome2"];
    [dummyEvent setDetails:@"details"];
    [dummyEvent setTitle:@"title"];
    [dummyEvent setCategory:@"category"];
    
    // log our old points
    int oldpoints = [self.userBetManager.userData.points intValue];
    
    // call function that should update and pay out the bet
    NSArray *eventArray = [[NSArray alloc] initWithObjects:dummyEvent, nil];
    [self.userBetManager handleContent:eventArray];
    
    int newpoints = [self.userBetManager.userData.points intValue];
    
    NSLog(@"Old points is %d, new points is %d",oldpoints, newpoints);
    XCTAssertTrue(newpoints - oldpoints == 200,@"Bet was not paid out with right amount");
}

/*
 * (void) testOutstandingBets
 *
 * We just changed the status of the only outstanding bet, so now there should be none
 */
- (void) dtestOutstandingBets
{
    XCTAssertTrue([[self.userBetManager outstandingBets] count] == 0,@"Should be no outstanding bets");
}

/*
 * (void) testBetHistory
 *
 * We now have one total bet, so should be one
 */
- (void) etestBetHistory
{
    XCTAssertTrue([[self.userBetManager betHistory] count] == 1, @"Should be one in bet history");
}

/*
 * (void) testBestBet
 *
 * See if our win has now become our best bet (meaning most points won from a single bet)
 */
- (void) ftestBestBet
{
    XCTAssertTrue([self.userBetManager.userData.bestBet intValue] == 200, @"Best bet didn't update");
}

/*
 * (void) testWinsAndLosses
 *
 * See if wins and losses updated appropriately
 */
- (void) gtestWinsAndLosses
{
    XCTAssertTrue([self.userBetManager.userData.wins intValue] == 1, @"Wins incorrect");
    XCTAssertTrue([self.userBetManager.userData.losses intValue] == 0, @"Losses incorrect");
}

/*
 * (void) testLongestWinStreak
 *
 * See if our longest win streak is correct
 */
- (void) htestBestBet
{
    XCTAssertTrue([self.userBetManager.userData.longestWinStreak intValue] == 1, @"Longest win streak incorrect");
}

@end
