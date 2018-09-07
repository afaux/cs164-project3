README.md
project3

Spencer de Mars
Ainsley Faux

Our app iBet allows users to place bets on a variety of things ranging from the outcome of a sporting event to the winner of a reality TV show.

From the features listed in our design document we were able to include all of the mandatory features we outlined.  These include:

- A home screen that prominently displays points along with a link to the bet of the day as well as any bets the user has won or lost since they last logged in
- A "More bets" tab which allows users to browse other events that are available for betting.
- A "History" tab which allows users to see all of their past bets along with those outcomes
- Within "History", a "Stats" page that allows users to see their most important stats such as most won on a single bet, longest win streak, and total wins and losses

We originally stated in our design document that we would include leagues and leader boards if we had time.  Unfortunately we were not able to get to this part of the project.  We believe we would have been able to implement this had the technical difficulties of the project not proved far more time consuming than we anticipated.  Because our application both stores persistent data on the local machine through Core Data and communicates with a mySQL server database, we had to get up to speed on two different fairly complex mechanisms for communicating data.

Although the code itself is fairly well documented we would also like to clarify a little about our overall design:

First for vocabulary - For the purposes of this project, an Event is simply something on which a user can bet (the winner of game 7 of the Stanley Cup Quarter finals). A bet on the other hand is a users specific prediction which includes an Event as well as their predicted outcome and wager.

Next to explain a little about the mySQL aspect of the project:
At the URL http://cloud.cs50.net/~afaux/cs164/index.html you can find links to two important HTML forms, one for adding a new event and one for updating an event once it has occurred.  These are the way we as the administrators of the site would add new upcoming events and change the status of the event to declare the winning outcome.  We have been using them to test our application by entering and updating various events.  These script update what is essentially a list of event objects in the mySQL server.

When the application needs to fetch an event or list of events it runs other PHP scripts to fetch information from mySQL.  That information is then converted by PHP into JSON format and sent to the iOS application, which converts it into Objective C data structures.

Finally a point of clarification on the code and application use:
When using the application and pressing certain buttons like "Event of the Day" there may be a slight delay before the next page opens, and this is due to communication with mySQL.  It stems from the fact that communicating with the mySQL server is an asynchronous process because it involves a non-negligible amount of overhead time to execute the php query and fetch results from the server.  This is the same reason that in the code we use delegates to interact with the GlobalEventManager.  So basically the process is initiated in some earlier method, and then once the data has arrived connectionDidFinish in GlobalEventManager is called, which can then send the final result to a delegate.
