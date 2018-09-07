//
//  MainViewController.h
//  project3
//
//  Spencer de Mars
//  Ainsley Faux
//
//  Header file for the MainViewController object, which handles homescreen
//  Full commenting of properties and methods can be found in the .m file.
//

#import <UIKit/UIKit.h>
#import "UserBetManager.h"
#import "GlobalEventManager.h"
#import "EventViewController.h"

@interface MainViewController : UIViewController <UITableViewDelegate,UserBetManagerDelegate,GlobalEventManagerDelegate>

// UI elements
@property (nonatomic, readwrite, weak) IBOutlet UILabel *pointsLabel;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *notificationLabel;
@property (nonatomic, readwrite, weak) IBOutlet UIButton *betOfTheDayButton;
@property (nonatomic, readwrite, weak) IBOutlet UITableView *updatesTableView;

@property (nonatomic, strong) EventViewController *eventViewController;

// core data
@property (nonatomic, readwrite, strong) UserBetManager *userBetManager;
@property (nonatomic, readwrite, strong) GlobalEventManager *globalEventManager;

-(IBAction)viewBetOfTheDay;
-(void)refresh;
@end
