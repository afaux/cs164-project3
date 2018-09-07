//
//  EventViewController.h
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

@interface EventViewController : UIViewController <UIAlertViewDelegate>

// UI elements
@property (nonatomic, readwrite, weak) IBOutlet UILabel *optionalLabel;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *eventDescriptionLabel;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *wagerLabel;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *outcome1Label;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *outcome2Label;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *payoff1Label;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *payoff2Label;
@property (nonatomic, readwrite, weak) IBOutlet UISlider *wagerSlider;
@property (nonatomic, readwrite, weak) IBOutlet UIButton *pickOutcome1;
@property (nonatomic, readwrite, weak) IBOutlet UIButton *pickOutcome2;

// public properties
@property (nonatomic, readwrite, strong) Event *event;
@property (nonatomic, strong) UserBetManager *userBetManager;
// stores user's wager from the slider
@property (nonatomic, readwrite, strong) NSNumber *userWager;

-(IBAction) placeBetWithOutcome:(UIButton *)outcome;
-(IBAction) wagerSliderDidMove;

@end
