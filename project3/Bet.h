//
//  Bet.h
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

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Bet : NSManagedObject

@property (nonatomic, retain) NSNumber * amountWagered;
@property (nonatomic, retain) NSNumber * predictedOutcome;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) Event *event;

@end
