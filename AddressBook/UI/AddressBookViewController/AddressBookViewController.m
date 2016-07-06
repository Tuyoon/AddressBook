//
//  AddressBookViewController.m
//  AddressBook
//
//  Created by Mac on 06.07.16.
//  Copyright © 2016 ta. All rights reserved.
//

#import "AddressBookViewController.h"
#import "AddressBookManager.h"
#import "CallManager.h"
#import "ContactTableViewCell.h"

@interface AddressBookViewController()<AddressBookManagerDelegate, UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *_tableView;
    NSArray *_contacts;
}

@end

@implementation AddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestAccess];
}

- (void)requestAccess {
    [AddressBookManager sharedManager].delegate = self;
    [self showActivityView];
    [[AddressBookManager sharedManager] requestAccess];
}

- (void)callContact:(Contact *)contact {
    [CallManager callPhoneNumber:contact.phone];
}

- (void)updateUI {
    [_tableView reloadData];
}

#pragma mark - AddressBookManagerDelegate

- (void)accessGrantedWithContatcs:(NSArray<__kindof Contact *> *)contacts {
    _contacts = contacts;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideActivityView];
        [self updateUI];
    });
}

- (void)accessDeniedWithError:(NSError *)error {
    [self hideActivityView];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Address book access error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
    
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    cell.contact = _contacts[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Contact *contact = _contacts[indexPath.row];
    [self callContact:contact];
}

@end
