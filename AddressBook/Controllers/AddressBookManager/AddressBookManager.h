//
//  AddressBookManager.h
//  AddressBook
//
//  Created by Mac on 06.07.16.
//  Copyright © 2016 ta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@class Contact;

@protocol AddressBookManagerDelegate <NSObject>

- (void)accessGrantedWithContatcs:(NSArray<__kindof Contact*> *)contacts;
- (void)accessDeniedWithError:(NSError *)error;

@end

@interface AddressBookManager : NSObject

@property (nonatomic, weak) id<AddressBookManagerDelegate> delegate;
+ (instancetype)sharedManager;
- (void)requestAccess;

@end
