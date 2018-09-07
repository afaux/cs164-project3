//
//  StatsViewController.h
//  project3
//
//  Spencer de Mars
//  Ainsley Faux
//
//  Header file for the StatsViewController object, which handles and displays user stats
//  Full commenting of properties and methods can be found in the .m file.
//

#import <UIKit/UIKit.h>
#import "UserBetManager.h"
#import "EventViewController.h"

@interface StatsViewController : UIViewController

@property (nonatomic, readwrite, weak) IBOutlet UILabel *pointsLabel;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *winsLabel;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *lossesLabel;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *winStreakLabel;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *bestBetLabel;

@property (nonatomic, strong) UserBetManager *userBetManager;

@end
