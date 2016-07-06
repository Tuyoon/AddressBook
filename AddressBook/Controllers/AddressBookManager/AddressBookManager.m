//
//  AddressBookManager.m
//  AddressBook
//
//  Created by Mac on 06.07.16.
//  Copyright © 2016 ta. All rights reserved.
//

#import "AddressBookManager.h"
#import <Contacts/Contacts.h>

@import AddressBook;

@implementation AddressBookManager {
    struct {
        unsigned int accessGranted : 1;
        unsigned int accessDenied : 1;
    }_delegateFlags;
    CNContactStore *_store;
}

static AddressBookManager *instance;
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AddressBookManager alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _store = [[CNContactStore alloc] init];
    }
    
    return self;
}

- (void)setDelegate:(id<AddressBookManagerDelegate>)delegate {
    if ([delegate respondsToSelector:@selector(accessGrantedWithContatcs:)]) {
        _delegateFlags.accessGranted = 1;
    }
    if ([delegate respondsToSelector:@selector(accessDeniedWithError:)]) {
        _delegateFlags.accessDenied = 1;
    }
    _delegate = delegate;
}

- (void)requestAccess {
    
    __weak AddressBookManager *wSelf = self;
    [_store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        __strong AddressBookManager *sSelf = wSelf;
        if (!granted) {
            [sSelf informAboutAccessDeniedWithError:error];
            return;
        }
        [sSelf accessContacts];
    }];
}

- (void)accessContacts {
    NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
    NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:_store.defaultContainerIdentifier];
    NSError *error;
    NSArray *cnContacts = [_store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
    
    if (error) {
        [self informAboutAccessDeniedWithError:error];
        return;
    }
    
    NSArray *contacts = [self readContacts:cnContacts];
    [self informAboutAccessGranted:contacts];
    
}

- (NSArray *)readContacts:(NSArray *)cnContacts {
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
    for (CNContact *cnContact in cnContacts) {
        Contact *contact = [[Contact alloc] init];
        contact.firstName = cnContact.givenName;
        contact.lastName = cnContact.familyName;
        UIImage *image = [UIImage imageWithData:cnContact.imageData];
        contact.image = image;
        CNLabeledValue *phone = [cnContact.phoneNumbers firstObject];
        contact.phone = [phone.value stringValue];
        [contacts addObject:contact];
    }
    
    return [NSArray arrayWithArray:contacts];
}

- (void)informAboutAccessGranted:(NSArray<__kindof Contact*> *)contacts {
    if (_delegateFlags.accessGranted) {
        [_delegate accessGrantedWithContatcs:contacts];
    }
}

- (void)informAboutAccessDeniedWithError:(NSError *)error {
    if (_delegateFlags.accessDenied) {
        [_delegate accessDeniedWithError:error];
    }
}

@end
