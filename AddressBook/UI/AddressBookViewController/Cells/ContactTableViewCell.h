//
//  ContactTableViewCell.h
//  AddressBook
//
//  Created by Mac on 06.07.16.
//  Copyright © 2016 ta. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Contact;
@interface ContactTableViewCell : UITableViewCell

@property (nonatomic, strong) Contact *contact;

@end
