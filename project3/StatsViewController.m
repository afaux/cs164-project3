//
//  StatsViewController.m
//  project3
//
//  Spencer de Mars
//  Ainsley Faux
//
//  Defines StatsViewController which handles and displays user stats.
//

#import "StatsViewController.h"
#import "UserBetManager.h"

@interface StatsViewController ()

@end

@implementation StatsViewController

@synthesize pointsLabel=_pointsLabel;
@synthesize winsLabel=_winsLabel;
@synthesize lossesLabel=_lossesLabel;
@synthesize winStreakLabel=_winStreakLabel;
@synthesize bestBetLabel=_bestBetLabel;

@synthesize userBetManager=_userBetManager;


/*
 * (void)viewDidLoad
 *
 * Initiazes page on load
 */

- (void)viewDidLoad
{    
    // retrieve user stats
    UserData *userData = self.userBetManager.userData;
    
    // update labels
    self.pointsLabel.text = [userData.points stringValue];
    self.winsLabel.text = [userData.wins stringValue];
    self.lossesLabel.text = [userData.losses stringValue];
    self.winStreakLabel.text = [userData.longestWinStreak stringValue];
    self.bestBetLabel.text = [userData.bestBet stringValue];
     
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

@end
