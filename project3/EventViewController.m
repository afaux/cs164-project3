//
//  EventViewController.m
//  project3
//
//  Spencer de Mars
//  Ainsley Faux
//
//  Header file for the EventsViewController object, which displays additional user in a category
//  Full commenting of properties and methods can be found in the .m file.
//

#import "EventViewController.h"
#import "MainViewController.h"

@interface EventViewController ()

// stores the maximum wager value for the event displayed
@property (nonatomic, readwrite, strong) NSNumber *maxWager;
// stores user's point total
@property (nonatomic, readwrite, strong) NSNumber *userPoints;

@end

@implementation EventViewController

@synthesize optionalLabel=_optionalLabel;
@synthesize eventDescriptionLabel=_eventDescriptionLabel;
@synthesize wagerLabel=_wagerLabel;
@synthesize outcome1Label=_outcome1Label;
@synthesize outcome2Label=_outcome2Label;
@synthesize payoff1Label=_payoff1Label;
@synthesize payoff2Label=_payoff2Label;
@synthesize wagerSlider=_wagerSlider;
@synthesize pickOutcome1=_pickOutcome1;
@synthesize pickOutcome2=_pickOutcome2;

@synthesize event=_event;
@synthesize userWager=_userWager;
@synthesize maxWager=_maxWager;
@synthesize userPoints=_userPoints;

// core data
@synthesize userBetManager = _userBetManager;


/*
 * (IBAction)placeBetWithOutcome:(UIButton *)outcome
 *
 *  Handles placing of a bet with the specified outcome
 */

-(IBAction)placeBetWithOutcome:(UIButton *)outcome
{
    // retreive outcome
    NSNumber *userOutcome = [NSNumber numberWithInteger:outcome.tag];
    
    // save to core data
    bool result = [self.userBetManager placeBetOnEvent:self.event WithOutcome:userOutcome AndWager:self.userWager];

    // containers for alert
    NSString *message = [NSString string];
    NSString *title = [NSString string];
    
    if(result){
        title = @"Success!";
        message = [NSString stringWithFormat:@"You've placed a bet on the %@!", self.event.title ];
    }
    else{
        title = @"Oops!";
        message = @"You've already bet on this!";
    }
    
    // create alert object
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"Close"
                                          otherButtonTitles:nil];
    
    // show alert
    [alert show];

}



/*
 * (void)viewDidLoad
 *
 * Initiazes page on load
 */

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    // find user's point total
    self.userPoints = self.userBetManager.userData.points;
    
    // calculate maxWager and payoff values
    self.maxWager = [NSNumber numberWithFloat:([self.event.maxWager floatValue] * [self.userPoints floatValue])];
    
    // update UI with event info
    self.navigationItem.title = self.event.title;
    self.optionalLabel.text = self.event.category;
    self.eventDescriptionLabel.text = self.event.details;
    self.outcome1Label.text = self.event.outcome1;
    self.outcome2Label.text = self.event.outcome2;
  
    // set default wager and update slider
    self.userWager = [NSNumber numberWithInt:1];
    self.wagerSlider.value = 0;
    self.wagerLabel.text = [NSString stringWithFormat:@"%d points", [self.userWager intValue]];
    
    // update payoff labels
    int payoff1 = (int)[self.userWager intValue]*[self.event.odds1 floatValue];
    int payoff2 = (int)[self.userWager intValue]*[self.event.odds2 floatValue];
    self.payoff1Label.text = [NSString stringWithFormat:@"%d points", payoff1];
    self.payoff2Label.text = [NSString stringWithFormat:@"%d points", payoff2];
}


/*
 * (IBAction)wagerSliderDidMove
 *
 * Handles updating userWager value when user moves the slider
 */ 

-(IBAction)wagerSliderDidMove
{
    // convert slider position to an int 
    int value = (int)(self.wagerSlider.value * [self.maxWager intValue]);
    
    // don't let user select 0 
    if(value == 0)
        value = 1;
    
    // store value in slider
    self.userWager = [NSNumber numberWithInt:value];
    
    // update wager label label
    self.wagerLabel.text = [NSString stringWithFormat:@"%d points", value];    
    
    // update payoff labels
    int payoff1 = (int)[self.userWager intValue]*[self.event.odds1 floatValue];
    int payoff2 = (int)[self.userWager intValue]*[self.event.odds2 floatValue];
    self.payoff1Label.text = [NSString stringWithFormat:@"%d points", payoff1];
    self.payoff2Label.text = [NSString stringWithFormat:@"%d points", payoff2];
}

/*
 * (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 *
 * Only support portrait orientation
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation = UIInterfaceOrientationPortrait);
}

/*
 * (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 *
 * Catches and responds to user pressing "otherButtons" in UIAlertViews
 */
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // user presses "Close"
    if(buttonIndex==0)
        [self.navigationController popViewControllerAnimated:YES];
    
}
@end
