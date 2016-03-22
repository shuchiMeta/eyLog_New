//
//  main.m
//  eyLog
//
//  Created by Lakshaya Chhabra on 23/06/14.
//  Copyright (c) 2014 MetaDesign Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        
        /*
         This function instantiates the application object from the principal class and instantiates the delegate (if any) from the given class and sets the delegate for the application. It also sets up the main event loop, including the application’s run loop, and begins processing events. If the application’s Info.plist file specifies a main nib file to be loaded, by including the NSMainNibFile key and a valid nib file name for the value, this function loads that nib file.
         Despite the declared return type, this function never returns. For more information on how this function behaves, see
         */
       
               return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
