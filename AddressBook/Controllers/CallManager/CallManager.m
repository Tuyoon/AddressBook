//
//  CallManager.m
//  AddressBook
//
//  Created by Mac on 06.07.16.
//  Copyright © 2016 ta. All rights reserved.
//

#import "CallManager.h"
#import <UIKit/UIKit.h>

NSString* telProtocol = @"tel:";
NSString* telPromptProtocol = @"telprompt:";

static CallManager* instance;
@implementation CallManager{
    NSURL* _phoneURL;
}

+ (BOOL)callPhoneNumber:(NSString*)phone {
    return [self callPhoneURLNumber:phone];
}

+ (BOOL)callPhoneURLNumber:(NSString*)phone {
    return [[self sharedInstance] callPhoneURLNumber:phone];
}

+ (instancetype)sharedInstance{
    if(instance == nil){
        instance = [[CallManager alloc] init];
    }
    return instance;
}

- (BOOL)callPhoneURLNumber:(NSString*)phone {
    if (phone.length == 0 || ![[[UIDevice currentDevice] model] isEqualToString:@"iPhone"]) {
        [self informAboutError];
        return NO;
    }
    
    NSString *phoneString = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneString = [telProtocol stringByAppendingString:phoneString];
    _phoneURL = [NSURL URLWithString:phoneString];
    [self call];
    
    return YES;
}

- (void)call {
    if ([[UIApplication sharedApplication] canOpenURL:_phoneURL]) {
        [[UIApplication sharedApplication] openURL:_phoneURL];
    }
    else {
        [self informAboutError];
    }
}

- (void)informAboutError {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Phone calling not supported" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

@end
