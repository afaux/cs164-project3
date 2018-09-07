//
//  AppDelegate.h
//  project3
//
//  Spencer de Mars
//  Ainsley Faux 
//
//  Header file for the AppDelegate
//

#import <UIKit/UIKit.h>
#import "UserBetManager.h"
#import "GlobalEventManager.h"
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) UINavigationController *mainNavigationController;
@property (strong, nonatomic) UINavigationController *categoryNavigationController;
@property (strong, nonatomic) UINavigationController *historyNavigationController;
@property (strong, nonatomic) MainViewController *mainViewController;


// for core data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readwrite, strong, nonatomic) UserBetManager *userBetManager;
@property (readwrite, strong, nonatomic) GlobalEventManager *globalEventManager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
