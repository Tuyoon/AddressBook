//
//  ContactTableViewCell.m
//  AddressBook
//
//  Created by Mac on 06.07.16.
//  Copyright © 2016 ta. All rights reserved.
//

#import "ContactTableViewCell.h"
#import "Contact.h"

@implementation ContactTableViewCell {
    IBOutlet UILabel *_nameLabel;
    IBOutlet UIImageView *_imageView;
    IBOutlet UILabel *_phoneNameLabel;
}


- (void)prepareForReuse {
    _nameLabel.text = nil;
    _phoneNameLabel.text = nil;
    _imageView.image = nil;
}

- (void)updateUI {
    _nameLabel.text = [self.contact displayName];
    _phoneNameLabel.text = self.contact.phone;
    _imageView.image = self.contact.image;
}

- (void)setContact:(Contact *)contact {
    _contact = contact;
    [self updateUI];
}

@end
