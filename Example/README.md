# Objective-C dependency injection in 4 easy steps

In this example we'll show you how to easily apply dependency injection (DI) in your code with [Reliant](https://github.com/appfoundry/Reliant).

In a few easy steps you'll learn how to set up a very simple 'Hello World' DI scenario and along the way we'll explain why DI is actually kinda neat :).

## Step 1: Importing Reliant
Let's start by creating a new project and make it an 'empty' application. You know how to do this so let's not go into detail here.

Thanks to CocoaPods this is as easy as creating a Podfile and adding the following lines:

```
pod 'Reliant'
```

Then run

```
pod install
```

Now close XCode, open the newly created '.xcworkspace' file and you're done!

## Step 2: Bootstrapping Reliant
We'll need to configure Reliant in our project so that:
* it gets loaded when the app starts
* it uses our own configuration data (which classes should be injected, etc...)

Let's do just that. So...

### It needs to be loaded when the app starts

Let's open up 'AppDelegate.m' and modify it to look like this:

**AppDelegate.m**
```objective-c
#import "AppDelegate.h"
#import <Reliant/Reliant.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Initialize Reliant
    [self ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[AppConfiguration class]];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
// Rest of your AppDelegate file ...
```

What we did here is:
* **Import** Reliant.h
* **Bootstrap** Reliant: we tell Reliant to create a working context that uses our own custom configuration for dependency injection.
This configuration is something we'll set up later. You'll notice that this code doesn't compile, which is perfectly normal since we did
not yet create the 'AppConfiguration' class yet.

Done!

### It needs to use our configuration data

In the previously shown code block we used a 'configuration' class called 'AppConfiguration'. Let's create this class.

**AppConfiguration.m**
```objective-c
#import "AppConfiguration.h"

@implementation AppConfiguration

@end
```

This is a plain old Objective-C class. Nothing out of the ordinary. You'll notice however that it does not really say or do anything.
Once we start defining classes that should be injected throughout our project, this is where we'll configure them.

For now, just make sure to import 'AppConfiguration.h' in your 'AppDelegate' so that your code compiles.

## Step 3: Using Reliant

***Note:*** For simplicity's sake we are writing most of our code in the AppDelegate class. Of course, you would normally use Reliant to inject other classes such as your ViewControllers, Services, etc... We're just trying to make this sample code as simple as possible.

Let's create a simple Hello World case where we use a 'Greeter' service that is injected by Reliant.

### But first: the implementation _without_ Reliant

We create a 'protocol' (or interface) for our Greeter service.

**Greeter.h**
```objective-c
#import <Foundation/Foundation.h>

@protocol Greeter <NSObject>

- (NSString *)sayHelloTo:(NSString *)name;

@end
```

Then we create an implementation following this protocol.

**FriendlyGreeter.h**
```objective-c
#import <Foundation/Foundation.h>
#import "Greeter.h"

@interface FriendlyGreeter : NSObject <Greeter>

@end
```

**FriendlyGreeter.m**
```objective-c
#import "FriendlyGreeter.h"

@implementation FriendlyGreeter

-(NSString *)sayHelloTo:(NSString *)name {
    return [NSString stringWithFormat:@"Hi, %@! How are you?", name];
}

@end
```

Long story short, friendly greeter is friendly. Yay!

Now for the important part. Using this service in our AppDelegate means that we need to instantiate ‘FriendlyGreeter'.

**AppDelegate.m**
```objective-c
#import "AppDelegate.h"
#import "AppConfiguration.h"
#import <Reliant/Reliant.h>
#import "FriendlyGreeter.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize Reliant
    [self ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[AppConfiguration class]];

    // Saying hello
    id<Greeter> greeter = [[FriendlyGreeter alloc] init];
    NSLog(@"Greeting: %@", [greeter sayHelloTo:@"dude"]);

    // Rest of AppDelegate.m ...
```

As you can see, we:
* imported "FriendlyGreeter.h"
* instantiated "FriendlyGreeter" and called 'sayHelloTo:'

Running this code outputs:
```
Greeting: Hi, dude! How are you?
```

And this works fine... However...

In a perfect world, we wouldn't need to have this **hard dependency** on
"FriendlyGreeter" in our code. Instead, we would only need to use the protocol, "Greeter".
Well, this is exactly what **dependency injection** does for us. It injects classes we are depending on
so that we do not need to hardcode instantiate them ourselves. It takes this control away from the '*depending*' class
 and puts the control somewhere outside. In our case Reliant will take care of it. That is what **Inversion of Control** means.
 Tadaah!

 ### So, without further ado: the implementation *with* Reliant

 **AppDelegate.h**
 ```objective-c
#import <UIKit/UIKit.h>
#import "Greeter.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<Greeter> greeter;

@end
```
We create a **greeter @property**, using only the protocol and not mentioning the actual implementation.
We'll later tell Reliant to find this property and inject the correct implementation.

**AppDelegate.m**
```objective-c
#import "AppDelegate.h"
#import "AppConfiguration.h"
#import <Reliant/Reliant.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize Reliant
    [self ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[AppConfiguration class]];

    // Saying hello
    NSLog(@"Greeting: %@", [self.greeter sayHelloTo:@"dude"]);

    // Rest of AppDelegat.m ...
```
We **removed the hard dependency** on FriendlyGreeter by:
* removing the import statement
* removing the init code

We now remain with only:
* the greeter @property
* a call to that property using **only the protocol**


We **do not need to instantiate this property**. Reliant does this for us. At least we'll tell it do so with these final pieces of code:

**AppConfiguration.m**
```objective-c
#import "AppConfiguration.h"
#import "FriendlyGreeter.h"

@implementation AppConfiguration

- (id<Greeter>) createSingletonGreeter {
    return [[FriendlyGreeter alloc] init];
}

@end
```
We tell Reliant to create a **singleton** for Greeter and inject it in any Reliant enabled class (see [self ocsInject]) where a @property named 'greeter' exists.
As you see, it is only here that we explicitely instantiate an actual Greeter implementation, in this case 'FriendlyGreeter'.

Reliant uses this code (our configuration class) to discern which properties it should inject and how they should be instantiated.
It uses the last part of the function name (createSingleton\*THISPART\*) to know the property name
you are using throughout your code. Of course Reliant offers a lot more power such as aliases, eager loading,
etc. but you can read up on this in Reliant's excellent [documentation](https://github.com/appfoundry/Reliant/wiki).

All that is left for us to do now is to tell Reliant to inject our DI-dependencies in our depending class, in this case the AppDelegate class.

Just add one line:
```objective-c
[self ocsInject]
```
Our final AppDelegate implementation now looks like this:

**AppDelegate.m**
```objective-c
#import "AppDelegate.h"
#import "AppConfiguration.h"
#import <Reliant/Reliant.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize Reliant
    [self ocsBootstrapAndBindObjectContextWithConfiguratorFromClass:[AppConfiguration class]];

    // Perform Reliant injection on self
    [self ocsInject];

    // Saying hello
    NSLog(@"Greeting: %@", [self.greeter sayHelloTo:@"dude"]);

    // Rest of AppDelegate.m ...
```

That's it! You now have a dependency injected implementation of your AppDelegate code.

##Step 4: Profit!

Let's say we would like to quickly change the Greeter implementation to 'UnfriendlyGreeter'. All we need to do is change our Configuration class as such:

**AppConfiguration.m**
```objective-c
#import "AppConfiguration.h"
#import "UnfriendlyGreeter.h"

@implementation AppConfiguration

- (id) createSingletonGreeter {
    return [[UnfriendlyGreeter alloc] init];
}

@end
```
And presto! All usages of the greeter @property will now be injected with 'UnfriendlyGreeter' instead.

You can probably see how Dependency Injection / Inversion of Control can be **very** convenient,
for example in a unit testing scenario where you'd like your tested class to call a mock service instead of the real service.
Just tell your test to inject the property with a mock and you’re done.
