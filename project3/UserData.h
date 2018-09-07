//
//  UserData.h
//  project3
//
//  Spencer de Mars
//  Ainsley Faux
//
//  Tracks persistent user data statistics.  This allows us to keep a local copy of this often-used
//  data for easy access by all controllers, and makes it easy to save and retrieve the data as well
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserData : NSManagedObject

@property (nonatomic, retain) NSNumber * bestBet;
@property (nonatomic, retain) NSNumber * longestWinStreak;
@property (nonatomic, retain) NSNumber * losses;
@property (nonatomic, retain) NSNumber * points;
@property (nonatomic, retain) NSNumber * wins;
@property (nonatomic, retain) NSDate * lastLogin;
@property (nonatomic, retain) NSNumber * currentWinStreak;

@end
