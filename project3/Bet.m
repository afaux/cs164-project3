//
//  Bet.m
//  project3
//
//  Spencer de Mars
//  Ainsley Faux
//
//  This serves 2 purposes:
//  1) Represent a helper class / encapsulation of a bet, which is a wager a user has made 
//  on a predicted outcome of a given event.
//  2) Act as an NSManagedObject to store bets in Core Data
//

#import "Bet.h"
#import "Event.h"


@implementation Bet

// amount user wagered on this bet
@dynamic amountWagered;
// predicted outcome: 1 for outcome 1, 2 for outcome 2
@dynamic predictedOutcome;
// Date bet was made
@dynamic creationDate;
// associated event
@dynamic event;

@end
