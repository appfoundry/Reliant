//
//  OCSScopeFactory.h
//  Reliant
//
//  Created by Michael Seghers on 22/08/14.
//
//

#import <Foundation/Foundation.h>

@protocol OCSScope;

@protocol OCSScopeFactory <NSObject>

- (id<OCSScope>)scopeForName:(NSString *) name;

@end
