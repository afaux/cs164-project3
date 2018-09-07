//
//  GlobalBetManager.m
//  project3
//
//  Spencer de Mars
//  Ainsley Faux 
//
//  Defines the GlobalEventManager model which intefaces with the SQL database to retrieve information on bets.
//  Packages each betting opportunity in an Event object.
//

#import "GlobalEventManager.h"

@implementation GlobalEventManager

@synthesize delegate=_delegate;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize receivedData=_receivedData;
@synthesize receivedString=_receivedString;

/*
 * (id) init
 *
 * Initializes the bet manager by loading all bet information from Core Data and saving it in properties
 */
- (id) initWithManagedObjectContext:(NSManagedObjectContext *)context {
    self = [super init];
    if(self) {
        self.managedObjectContext = context;
    }
    return self;
}


/*
 * (void)eventOfTheDay
 *
 * Fetches the featured event for this day that users can bet on
 */

- (void) eventOfTheDayWithDelegate:(id <GlobalEventManagerDelegate>) delegate 
{
    self.delegate = delegate;
    
    // create a URL request
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:
                             [NSURL URLWithString:@"https://cloud.cs50.net/~afaux/cs164/eventOfDayRequest.php"]];
    [request setHTTPMethod:@"POST"];
    [request setCachePolicy:NSURLCacheStorageNotAllowed];
    [request setTimeoutInterval:5.0];
    
    // create URL connection
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // save data if connection was successful
    if (connection){
        self.receivedData = [NSMutableData data];
    }
}

/*
 * (void)eventsChangesSince:(NSNumber *)unixtimestamp  
 *
 * Fetches events since a specified time
 */

- (void)eventChangesSince:(NSNumber *)unixtimestamp WithDelegate:(id<GlobalEventManagerDelegate> ) delegate
{
    self.delegate = delegate;
    
    // create a URL request
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:
                                   [NSURL URLWithString:@"https://cloud.cs50.net/~afaux/cs164/eventRequest.php"]];
    [request setHTTPMethod:@"POST"];
    [request setCachePolicy:NSURLCacheStorageNotAllowed];
    [request setTimeoutInterval:5.0];
   
    // create and encode URL post string
    NSString *postString = [NSString stringWithFormat: @"timestamp=%d",[unixtimestamp intValue]];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // create URL connection
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // save data if connection was successful
    if (connection){
        self.receivedData = [NSMutableData data];
    }
}


/*
 * (void) eventsForCategory:(NSString *)category 
 *
 * Fetches an array of all active events for the desired category.  An active event is one for which we are
 * still accepting bets for.
 */

- (void) eventsForCategory:(NSString *)category WithDelegate:(id <GlobalEventManagerDelegate>) delegate
{
    // create a URL request
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:
                                   [NSURL URLWithString:@"https://cloud.cs50.net/~afaux/cs164/eventRequest.php"]];
    [request setHTTPMethod:@"POST"];
    [request setCachePolicy:NSURLCacheStorageNotAllowed];
    [request setTimeoutInterval:5.0];
    
    // create and encode URL post string
    NSString *postString = [NSString stringWithFormat: @"category=%@",category];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // create URL connection
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // save data if connnection was succesful
    if (connection){
        self.receivedData = [NSMutableData data];
    }
}

// save context for core data
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

#pragma mark NSURLConnection methods

/*
 * (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
 *
 * This method is called when the server has determined that it has enough information to create the NSURLResponse.
 */

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // 	
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
	
    
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{    
    // inform the user
    UIAlertView *didFailWithErrorMessage = [[UIAlertView alloc] initWithTitle: @"Error" 
                                                                      message: @"Couldn't access server. Please try again" 
                                                                     delegate: self 
                                                            cancelButtonTitle: @"Ok"
                                                            otherButtonTitles: nil];
    [didFailWithErrorMessage show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // convert received data to string
    self.receivedString = [[NSString alloc] initWithData: self.receivedData encoding:NSUTF8StringEncoding];	
    
    // initialize parser and parse string
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSArray *result = [parser objectWithString:self.receivedString error:nil];
    
    // container to be returned
    NSMutableArray *events = [[NSMutableArray alloc] init];
    
    // check that something was returned
    if((![result count]) == 0)
    {
             // iterate over results
        for(NSDictionary *dict in result)
        {
            // create an event object for each result
            Event *e = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
            
            // populate fields of event object
            [e setIdNumber:[NSNumber numberWithInt:[[dict objectForKey:@"idNum"] intValue]]];
            [e setCategory:[dict objectForKey:@"category"]];
            [e setTitle:[dict objectForKey:@"title"]];
            [e setDetails:[dict objectForKey:@"details"]];
            [e setOutcome1:[dict objectForKey:@"outcome1"]];
            [e setOdds1:[NSNumber numberWithFloat:[[dict objectForKey:@"odds1"] floatValue]]];
            [e setOutcome2:[dict objectForKey:@"outcome2"]];
            [e setOdds2:[NSNumber numberWithFloat:[[dict objectForKey:@"odds2"] floatValue]]];
            [e setMaxWager:[NSNumber numberWithFloat:[[dict objectForKey:@"maxWager"] floatValue]]];
            [e setStatus:[NSNumber numberWithInt:[[dict objectForKey:@"status"] intValue]]];
            
            // add to array to be returned
            [events addObject:e];
        }
    }
    
    // inform calling function that data has been received
    [self.delegate handleContent:events];
}
@end

