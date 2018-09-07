//
//  AppDelegate.m
//  project3
//
//  Spencer de Mars
//  Ainsley Faux
//
//  Definition of the AppDelegate
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "UserBetManager.h"
#import "CategoryViewController.h"
#import "HistoryViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize mainNavigationController=_mainNavigationController;
@synthesize categoryNavigationController=_categoryNavigationController;
@synthesize historyNavigationController=_historyNavigationController;
// core data properties
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize userBetManager = _userBetManager;
@synthesize globalEventManager = _globalEventManager;
@synthesize mainViewController = _mainViewController;

/* (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 *
 *
 * Configures application when launched
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // initialize toolbar controller
    self.tabBarController = [[UITabBarController alloc] init];
    
    // core data
    self.userBetManager = [[UserBetManager alloc] initWithManagedObjectContext:[self managedObjectContext]];
    self.globalEventManager = [[GlobalEventManager alloc] initWithManagedObjectContext:[self managedObjectContext]];
        
    // initialize view controllers
    MainViewController *mainViewController=[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    CategoryViewController *categoryViewController=[[CategoryViewController alloc] initWithNibName:@"CategoryViewController" 
                                                                                            bundle:nil];
    HistoryViewController *historyViewController=[[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil]; 
    
    // initialize navigation controllers
    self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    self.categoryNavigationController = [[UINavigationController alloc] initWithRootViewController:categoryViewController];
    self.historyNavigationController = [[UINavigationController alloc] initWithRootViewController:historyViewController];
    
    // allow other view controllers to interface with bet manager
    mainViewController.userBetManager = self.userBetManager;
    categoryViewController.userBetManager = self.userBetManager;
    historyViewController.userBetManager = self.userBetManager;
    
    // allow other view controllers to interface with global event manager
    mainViewController.globalEventManager = self.globalEventManager;
    categoryViewController.globalEventManager = self.globalEventManager;
    self.userBetManager.globalEventManager = self.globalEventManager;
    
    // set navigation bar titles
    mainViewController.navigationItem.title = @"iBet";
    categoryViewController.navigationItem.title = @"More Bets";
    historyViewController.navigationItem.title = @"History";
   
    // set toolbar titles
    self.mainNavigationController.tabBarItem.title = @"iBet";
    self.categoryNavigationController.tabBarItem.title = @"More Bets";
    self.historyNavigationController.tabBarItem.title = @"History";
    
    // set toolbar images
    self.mainNavigationController.tabBarItem.image = [UIImage imageNamed:@"first"]; 
    self.categoryNavigationController.tabBarItem.image = [UIImage imageNamed:@"first"]; 
    self.historyNavigationController.tabBarItem.image = [UIImage imageNamed:@"first"]; 
    
    // set view controllers in TabBarController
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:self.mainNavigationController,self.categoryNavigationController,self.historyNavigationController, nil];
    
    // display everything
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    // make main view controller available for testing
    self.mainViewController = mainViewController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

/*
 * (void) applicationDidBecomeActive:(UIApplication *)application
 *
 * Refreshes with any bet updates since app was backgrounded
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self.userBetManager updateBetsWithDelegate:self.mainViewController];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Core Data stack
/*
 * The following is all for Core Data stuff
 */

/*
 * (void)saveContext
 *
 * Saves the current core data managed context, saving any changes made
 */
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

/*
 * (NSManagedObjectContext *)managedObjectContext
 *
 * Returns the managed object context for the application.
 * If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/*
 * (NSManagedObjectModel *)managedObjectModel
 *
 * Returns the managed object model for the application.
 * If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"project3" withExtension:@"mom"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/*
 * (NSPersistentStoreCoordinator *)persistentStoreCoordinator
 *
 * Returns the persistent store coordinator for the application.
 * If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"project3.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Error: %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory
/*
 * (NSURL *)applicationDocumentsDirectory
 *
 * Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
