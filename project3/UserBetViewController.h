//
//  UserBetViewController.h
//  project3
//
//  Spencer de Mars
//  Ainsley Faux
//
//  Header file for the UserBetViewController object, which displays details of a past user 
//  Full commenting of properties and methods can be found in the .m file.
//

#import <UIKit/UIKit.h>
#import "UserBetManager.h"
#import "EventViewController.h"

@interface UserBetViewController : UIViewController

@property (nonatomic, readwrite, weak) IBOutlet UILabel *categoryLabel;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *eventDetailsLabel;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *predictedOutcomeLabel;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *amountWageredLabel;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *pointsEarnedOrLostLabel;

@property(nonatomic, strong) Bet *bet;

@end
