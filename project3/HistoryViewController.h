//
//  HistoryViewController.h
//  project3
//
//  Spencer de Mars
//  Ainsley Faux
//
//  Header file for the HistoryViewController object, which displays a list of past user bets
//  Full commenting of properties and methods can be found in the .m file.
//

#import <UIKit/UIKit.h>
#import "UserBetManager.h"
#import "EventViewController.h"

@interface HistoryViewController : UITableViewController

@property (nonatomic, strong) NSArray *bets;
@property (strong, nonatomic) UserBetManager *userBetManager;

-(void)viewStats;

@end
