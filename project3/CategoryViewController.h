//
//  CategoryViewController.h
//  project3
//
//  Spencer de Mars
//  Ainsley Faux
//
//  Header file for the EventViewController object, which handles placing additional user bets
//  Full commenting of properties and methods can be found in the .m file.
//

#import <UIKit/UIKit.h>
#import "UserBetManager.h"
#import "GlobalEventManager.h"
#import "EventsViewController.h"
#import "EventViewController.h"

@interface CategoryViewController : UITableViewController <GlobalEventManagerDelegate>

@property (nonatomic, strong) UserBetManager *userBetManager;
@property (nonatomic, strong) GlobalEventManager *globalEventManager;
@end
