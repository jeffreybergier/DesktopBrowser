//
//  BrowserTabViewController.h
//  DesktopBrowser
//
//  Created by Jeffrey Bergier on 29/04/2018.
//  Copyright © 2018 Jeffrey Bergier. All rights reserved.
//

@import UIKit;
#import "BrowserTabConfiguration.h"

typedef void (^BrowserTabViewControllerCompletionHandler)(UIViewController* __nonnull vc,
                                                           BrowserTabConfiguration* __nonnull config,
                                                           BOOL shouldDelete);

@interface BrowserTabViewController : UIViewController

+ (UIViewController*)browserTabWithConfiguration:(BrowserTabConfiguration* __nonnull)configuration
                     configurationChangeDelegate:(id<BrowserTabConfigurationChangeDelegate> __nullable)delegate
                               completionHandler:(BrowserTabViewControllerCompletionHandler __nonnull)completionHandler;

@end
