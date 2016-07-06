//
//  Contact.m
//  AddressBook
//
//  Created by Mac on 06.07.16.
//  Copyright © 2016 ta. All rights reserved.
//

#import "Contact.h"

@implementation Contact

- (NSString *)displayName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
