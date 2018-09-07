//
//  Event.h
//  project3
//
//  Spencer de Mars
//  Ainsley Faux
//
//  This serves 2 purposes:
//  1) Represent a helper class / encapsulation of an event, which is essentially all the information
//  about an event the users have the opportunity to bet on
//  2) Act as an NSManagedObject to store events in Core Data
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bet;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSNumber * idNumber;
@property (nonatomic, retain) NSNumber * maxWager;
@property (nonatomic, retain) NSNumber * odds1;
@property (nonatomic, retain) NSString * outcome1;
@property (nonatomic, retain) NSString * outcome2;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * odds2;
@property (nonatomic, retain) Bet *bet;

@end
