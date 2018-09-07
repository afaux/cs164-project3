//
//  GlobalBetManager.h
//  project3
//
//  Spencer de Mars
//  Ainsley Faux 
//
//  Header file for the GlobalEventManager model which retrieves betting event information.
//  Full commenting of properties and methods can be found in the .m file.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "Bet.h"
#import "Event.h"
#import "SBJson.h"

@protocol GlobalEventManagerDelegate
- (void) handleContent:(NSArray *)eventsToDisplay;
@end

@interface GlobalEventManager : NSObject <NSURLConnectionDelegate>

@property(nonatomic, weak) id <GlobalEventManagerDelegate> delegate;
@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) NSString *receivedString;
@property(nonatomic, strong) NSMutableData *receivedData;


- (void) eventOfTheDayWithDelegate:(id <GlobalEventManagerDelegate>) delegate;
- (void) eventChangesSince:(NSNumber *)unixtimestamp WithDelegate:(id <GlobalEventManagerDelegate>) delegate;
- (void) eventsForCategory:(NSString *)category WithDelegate:(id <GlobalEventManagerDelegate>) delegate;
- (void)saveContext;

- (id) initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
