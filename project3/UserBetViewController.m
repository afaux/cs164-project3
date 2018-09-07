//
//  UserBetViewController.m
//  project3
//
//  Spencer de Mars
//  Ainsley Faux
//
//  Defines the UserBetViewController object, which displays details of a past user bet
//


#import "UserBetViewController.h"

@interface UserBetViewController ()

@end

@implementation UserBetViewController

@synthesize categoryLabel=_categoryLabel;
@synthesize eventDetailsLabel=_eventDetailsLabel;
@synthesize predictedOutcomeLabel=_predictedOutcomeLabel;
@synthesize amountWageredLabel=_amountWageredLabel;
@synthesize pointsEarnedOrLostLabel=_pointsEarnedOrLostLabel;

@synthesize bet=_bet;

/*
 * (void)viewDidLoad
 *
 * Initiazes page on load
 */

- (void)viewDidLoad
{
    
    NSString *outcome = [NSString string];
    NSString *netEarnings = [NSString string];
    
    int pointsEarnedOrLost;
    // determine users predicted outcome
    if([self.bet.predictedOutcome intValue] == 1){
        outcome = self.bet.event.outcome1;
        pointsEarnedOrLost = [self.bet.amountWagered intValue]*[self.bet.event.odds1 doubleValue];
 
        // determine if prediction was correct, update netEarnings string
        if([self.bet.event.status intValue] == 1)
            netEarnings = [NSString stringWithFormat:@"You earned %d points!", pointsEarnedOrLost];
        else if([self.bet.event.status intValue] == 2)
            netEarnings = [NSString stringWithFormat:@"You lost %d points!", pointsEarnedOrLost];
        else
            netEarnings = @"Bet hasn't been decided yet!";
        }
    
    else if([self.bet.predictedOutcome intValue] == 2)
    {
        outcome = self.bet.event.outcome2; 
        pointsEarnedOrLost = [self.bet.amountWagered intValue]*[self.bet.event.odds2 doubleValue];

        // determine if prediction was correct, update netEarnings string
        if([self.bet.event.status intValue] == 2)
            netEarnings = [NSString stringWithFormat:@"You earned %d points!", pointsEarnedOrLost];
        else if([self.bet.event.status intValue] == 1)
            netEarnings = [NSString stringWithFormat:@"You lost %d points!", pointsEarnedOrLost];
        else
            netEarnings = @"Bet hasn't been decided yet!";
    }
    
    // update UI
    self.navigationItem.title = self.bet.event.title;
    self.categoryLabel.text=self.bet.event.category;
    self.eventDetailsLabel.text=self.bet.event.details;
    self.predictedOutcomeLabel.text=outcome;
    self.amountWageredLabel.text=[NSString stringWithFormat: @"%d points", [self.bet.amountWagered intValue]];
    self.pointsEarnedOrLostLabel.text=netEarnings;
                                       

}


/*
 * (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 *
 * Only support portrait orientation
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
