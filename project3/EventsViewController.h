//
//  EventsViewController.h
//  project3
//
//  Spencer de Mars
//  Ainsley Faux
//
//  Header file for the EventsViewController object, which displays additional user in a category
//  Full commenting of properties and methods can be found in the .m file.
//

#import <UIKit/UIKit.h>
#import "UserBetManager.h"
#import "EventViewController.h"

@interface EventsViewController : UITableViewController

@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSArray *events;
@property (strong, nonatomic) UserBetManager *userBetManager;

@end
