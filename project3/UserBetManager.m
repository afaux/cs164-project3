//
//  UserBetManager.m
//  project3
//
//  Spencer de Mars
//  Ainsley Faux 
//
//  Defines the UserBetManager model which intefaces with Core Data to manage user-specific bets.
//  Packages each bet in an Bet object.
//

#import "UserBetManager.h"

@implementation UserBetManager


@synthesize userData = _userData;
@synthesize delegate = _delegate;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize globalEventManager = _globalEventManager;

/*
 * (id) init
 *
 * Initializes the bet manager by loading all bet information from Core Data and saving it in properties
 */
- (id) initWithManagedObjectContext:(NSManagedObjectContext *)context {
    self = [super init];
    if(self) {
        self.managedObjectContext = context;
        
        // load bet data
        // debug
        NSFetchRequest *betRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *betEntity = [NSEntityDescription entityForName:@"Bet" inManagedObjectContext:self.managedObjectContext];
        [betRequest setEntity:betEntity];
        
        NSError *error = nil;
        NSMutableArray *betResults = [[self.managedObjectContext executeFetchRequest:betRequest error:&error] mutableCopy];
        
        NSMutableArray *currentBets;
        if(betResults == nil) {
            currentBets = [[NSMutableArray alloc] init];
        }
        else {
            currentBets = betResults;
        }

        // load user data
        NSFetchRequest *userDataRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *userDataEntity = [NSEntityDescription entityForName:@"UserData" inManagedObjectContext:self.managedObjectContext];
        [userDataRequest setEntity:userDataEntity];
         
        error = nil;
        NSMutableArray *userDataResults = [[self.managedObjectContext executeFetchRequest:userDataRequest error:&error] mutableCopy];
        if([userDataResults count] == 0) {
            // this is a first time user, so give them starting user data
            UserData *u = (UserData *)[NSEntityDescription insertNewObjectForEntityForName:@"UserData" inManagedObjectContext:self.managedObjectContext];
            [u setPoints:[NSNumber numberWithInt:1000]];
            [u setWins:[NSNumber numberWithInt:0]];
            [u setLongestWinStreak:[NSNumber numberWithInt:0]];
            [u setBestBet:[NSNumber numberWithInt:0]];
            [u setLastLogin:[NSDate date]];
            [u setCurrentWinStreak:[NSNumber numberWithInt:0]];
            self.userData = u;
            
            [self saveContext];
        }
        // user has used app before so retrieved saved data
        else {
            UserData *userData = [userDataResults objectAtIndex:0];
            
            // update last login
            [userData setLastLogin:[NSDate date]];
            [self saveContext];
            
            self.userData = userData;
        }
    }
    
    return self;
}


/*
 * (NSArray *) betHistory
 *
 * Returns an array of all of the user's past bets in chronological order
 */
- (NSArray *) betHistory
{    
    // load bet data
    NSFetchRequest *betRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *betEntity = [NSEntityDescription entityForName:@"Bet" inManagedObjectContext:self.managedObjectContext];
    [betRequest setEntity:betEntity];
     
    // sort by creation date
    NSSortDescriptor *betSorter = [[NSSortDescriptor alloc] initWithKey:@"creationDate" 
                                                              ascending:NO];
    NSArray *betSorters = [[NSArray alloc] initWithObjects:betSorter, nil];
    [betRequest setSortDescriptors:betSorters];
    
    NSError *error = nil;
    NSMutableArray *betResults = [[self.managedObjectContext executeFetchRequest:betRequest error:&error] mutableCopy];
    
    return betResults;
}


/*
 * (NSArray *) outstandingBets 
 *
 * Returns an array of the user's current outstanding bets, which are bets the user has money on but
 * have not been decided either way yet
 */
- (NSMutableArray *) outstandingBets
{
    // load bet data
    NSFetchRequest *betRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *betEntity = [NSEntityDescription entityForName:@"Bet" inManagedObjectContext:self.managedObjectContext];
    [betRequest setEntity:betEntity];
    
    
    // only look for outstanding bets
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event.status == 0"];
    [betRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *betResults = [[self.managedObjectContext executeFetchRequest:betRequest error:&error] mutableCopy];
    
    return betResults;
}

/*
 * (bool) hasBetOnEvent:(Event *)event
 *
 * Returns whether the user has bet on this event
 */

- (bool) hasBetOnEvent:(NSNumber *)eventID
{
    // load bet data
    NSFetchRequest *betRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *betEntity = [NSEntityDescription entityForName:@"Bet" inManagedObjectContext:self.managedObjectContext];
    [betRequest setEntity:betEntity];
    
    // look for bets with given ID number
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"event.idNumber == %d",[eventID intValue]];
    [betRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *betResults = [[self.managedObjectContext executeFetchRequest:betRequest error:&error] mutableCopy];
    
    // if we found nothing then we have not bet on this event before
    if([betResults count] > 0) {
        return true;
    }
    else {
        return false;
    }
}

/*
 * - (void) handleContent:(NSArray *)eventsToDisplay
 *
 * Implemented for globalEventManagerDelagate.  Gives us the events that have changed status
 * since we last logged in, so that we can update the core data information regarding what bets 
 * we may have won or lost
 */
- (void) handleContent:(NSArray *)eventsToDisplay {
    
    // compile list of event ID numbers for all outstanding bets
    NSMutableArray *outstanding = [self outstandingBets];
    NSArray *updatedEvents = eventsToDisplay;
    
    // create a dictionary of updated events by event ID to use later
    NSMutableDictionary *updatedEventDict = [[NSMutableDictionary alloc] init];
    for(Event *e in updatedEvents) {
        [updatedEventDict setObject:e forKey:e.idNumber];
    }
    NSArray *keys = [updatedEventDict allKeys];
    
    NSMutableArray *updatedBets = [[NSMutableArray alloc] init];
    
    // for every bet check if its corresponding event is in the set that has changed status
    for(Bet *b in outstanding) {
        int eventID = [b.event.idNumber intValue];
        
        if([keys containsObject:[NSNumber numberWithInt:eventID]]) 
        {
            // if so go through everything needed to update our records given we have won/lost bet
            Event *updatedEvent = [updatedEventDict objectForKey:[NSNumber numberWithInt:eventID]];
            // if we won
            if([updatedEvent.status intValue] == [b.predictedOutcome intValue]) {
                int wonpoints;
                if([b.predictedOutcome intValue] == 1)
                    wonpoints = [b.amountWagered intValue] * (1.0 + [updatedEvent.odds1 doubleValue]);
                else 
                    wonpoints = [b.amountWagered intValue] * (1.0 + [updatedEvent.odds2 doubleValue]);
                
                // update best bet if necessary
                if(wonpoints > [self.userData.bestBet intValue])
                    self.userData.bestBet = [NSNumber numberWithInt:wonpoints];
                
                // update wins
                int newwins = [self.userData.wins intValue] + 1;
                self.userData.wins = [NSNumber numberWithInt:newwins];
                
                // update points
                int newpoints = [self.userData.points intValue] + wonpoints;
                self.userData.points = [NSNumber numberWithInt:newpoints];
                
                // update win streaks
                int newwinstreak = [self.userData.currentWinStreak intValue] + 1;
                self.userData.currentWinStreak = [NSNumber numberWithInt:newwinstreak];
                
                if(newwinstreak > [self.userData.longestWinStreak intValue])
                    self.userData.longestWinStreak = [NSNumber numberWithInt:newwinstreak];
            }
            // if we lost
            else {
                // end current win streak
                self.userData.longestWinStreak = [NSNumber numberWithInt:0];
                
                // update losses
                int newlosses = [self.userData.losses intValue] + 1;
                self.userData.losses = [NSNumber numberWithInt:newlosses];
            }
            
            // either way update the event status in our copy
            [b.event setStatus:updatedEvent.status];
             
            // save our changes
            [self saveContext];
            
            // add to our array of updated bets
            [updatedBets addObject:b];
        }
    }
    
    // delegate shit
    [self.delegate displayUpdatedBets:updatedBets];
}

/*
 * (bool) placeBetOnEvent:(Event *)event WithOutcome:(NSNumber *)outcome AndWager:(NSNumber *)wager 
 *
 *  Places the desired bet by adding it to our list of bets and saving it in Core Data
 */
- (bool) placeBetOnEvent:(Event *)event WithOutcome:(NSNumber *)outcome AndWager:(NSNumber *)wager 
{    
    // check if we have already bet on this event
    if([self hasBetOnEvent:event.idNumber]) {
        return false;
    }
    
    // first let's add it to our own set of bets
    int newpoints = [self.userData.points intValue] - [wager intValue];
    
    // update points
    self.userData.points = [NSNumber numberWithInt:newpoints];
    
    // save this bet in Core Data
    Bet *b = (Bet *)[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.managedObjectContext];
    [b setAmountWagered:wager];
    [b setPredictedOutcome:outcome];
    
    //[self.bets addObject:b];
    
    Event *e = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    //NSNumber *odds = event.odds;
    [e setOdds1:event.odds1];
    [e setOdds2:event.odds2];
    [e setOutcome1:event.outcome1];
    [e setOutcome2:event.outcome2];
    [e setStatus:event.status];
    [e setCategory:event.category];
    [e setIdNumber:event.idNumber];
    [e setTitle:event.title];
    [e setDetails:event.details];
    [b setCreationDate:[NSDate date]];
    
    // handle the relationships
    [b setEvent:e];
    [e setBet:b];
    
    // commit it to core data
    NSError *error = nil;
    if(![self.managedObjectContext save:&error]) {
        NSLog(@"Core data did not save successfully");
        return false;
    }
    
    return true;
}


/*
 * (void) updateBets
 *
 * checks to see if any oustanding bets have been resolved and updates our point totals if so
 */

- (void) updateBetsWithDelegate:(id<UserBetManagerDelegate>)delegate
{
    self.delegate = delegate;
    NSDate* lastLogin = self.userData.lastLogin;
    // subtract a day because the unix timestamps don't line up exactly depending on time zone and other factors
    int timesince = (int) [lastLogin timeIntervalSince1970] - (24*60*60);
    [self.globalEventManager eventChangesSince:[NSNumber numberWithInt:timesince] WithDelegate:self];
}
 
/*
 * (void) saveContext
 *
 * save context for core data, effectively commiting all of our changes
 */
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

@end
