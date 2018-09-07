//
//  UserBetManager.h
//  project3
//
//  Spencer de Mars
//  Ainsley Faux 
//
//  Header file for the Bet model which handles user-specific bet information
//  Full commenting of properties and methods can be found in the .m file.
//

#import <Foundation/Foundation.h>
#import "Bet.h"
#import "Event.h"
#import "UserData.h"
#import "GlobalEventManager.h"

// core data
#import <CoreData/CoreData.h>

@protocol UserBetManagerDelegate
-(void) displayUpdatedBets:(NSArray *)updatedBets;
@end

@interface UserBetManager : NSObject <GlobalEventManagerDelegate>

// core data
@property (readwrite, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (readwrite, strong, nonatomic) UserData *userData;
@property (readwrite, strong, nonatomic) GlobalEventManager *globalEventManager;

// delagate for communicating the updated bets back to mainViewController
@property(nonatomic, weak) id <UserBetManagerDelegate> delegate;

- (id) initWithManagedObjectContext:(NSManagedObjectContext *)context;
- (NSArray *) betHistory;
- (NSMutableArray *) outstandingBets;
- (bool) placeBetOnEvent:(Event *)event WithOutcome:(NSNumber *)outcome AndWager:(NSNumber *)wager;
- (void) updateBetsWithDelegate:(id<GlobalEventManagerDelegate>)delegate;
- (void) saveContext;
- (bool) hasBetOnEvent:(NSNumber *)eventID;

@end
