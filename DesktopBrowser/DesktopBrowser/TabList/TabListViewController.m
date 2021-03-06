//
//  TabListViewController.m
//  DesktopBrowser
//
//  Created by Jeffrey Bergier on 01/05/2018.
//  Copyright © 2018 Jeffrey Bergier. All rights reserved.
//

#import "TabListViewController.h"
#import "TabListTableViewController.h"
#import "NSException+DBR.h"
#import "BrowserTabConfiguration.h"
#import "UIBarButtonItem+DBR.h"
#import "BrowserTabViewController.h"
#import "BrowserTabViewControllerCacher.h"

@interface TabListViewController () <TabListTableViewControllerDelegate, BrowserTabConfigurationChangeDelegate>

@property (weak, nonatomic, nullable) TabListTableViewController* tableViewController;
@property (nonatomic, strong, nonnull) NSMutableArray<BrowserTabConfiguration*>* tabs;
@property (nonatomic, strong, nonnull) BrowserTabViewControllerCacher* cacher;

@end

@implementation TabListViewController

+ (UIViewController*)tabList;
{
    TabListViewController* listVC = [[TabListViewController alloc] init];
    [listVC setTitle:@"Big Boy"];
    UINavigationController* navigationVC = [[UINavigationController alloc] initWithRootViewController:listVC];
    return navigationVC;
}

- (instancetype)init;
{
    self = [super init];
    [NSException throwIfNilObject:self];
    _cacher = [[BrowserTabViewControllerCacher alloc] init];
    _tabs = [[NSMutableArray alloc] init];
    return self;
}

- (void)viewDidLoad;
{
    [super viewDidLoad];

    // configure childVC
    TabListTableViewController* tableViewController = [[TabListTableViewController alloc] init];
    [tableViewController setDelegate:self];
    [tableViewController setDataSource:[self tabs]];
    [self setTableViewController:tableViewController];
    [self addChildViewController:tableViewController];
    UIView* myview = [self view];
    UIView* subview = [tableViewController view];
    [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
    [myview addSubview:subview];
    [myview addConstraints:@[
                             [[myview heightAnchor] constraintEqualToAnchor:[subview heightAnchor]],
                             [[myview widthAnchor] constraintEqualToAnchor:[subview widthAnchor]],
                             [[myview centerXAnchor] constraintEqualToAnchor:[subview centerXAnchor]],
                             [[myview centerYAnchor] constraintEqualToAnchor:[subview centerYAnchor]]
                             ]];

    // configure toolbar items
    [[self navigationItem] setRightBarButtonItem:[UIBarButtonItem newAddButtonItemWithTarget:self action:@selector(addButtonTapped:)]];
}

- (IBAction)addButtonTapped:(id)sender;
{
    [[self tabs] addObject:[[BrowserTabConfiguration alloc] initWithURLString:@"https://www.duckduckgo.com"
                                                                    pageTitle:@"DuckDuckGo"
                                                                        scale:2
                                                            javascriptEnabled:YES]];
    [[self tableViewController] addedItemAtIndex:[[self tabs] count] - 1];
}

// MARK: TabListTableViewControllerDelegate

- (void)userSelectedTabConfiguration:(BrowserTabConfiguration* __nonnull)configuration;
{
    __weak TabListViewController* welf = self;
    UIViewController* tabVC = [[self cacher] newOrCachedBrowserTabWithConfiguration:configuration
                                                        configurationChangeDelegate:self
                                                                  completionHandler:
     ^(UIViewController * _Nonnull vc, BrowserTabConfiguration * _Nonnull configuration, BOOL shouldDelete)
     {
         void(^block)(void) = ^{
             if (!shouldDelete) { return; }
             [welf userDeletedTabConfiguration:configuration withCompletionHandler:nil];
         };
         [vc dismissViewControllerAnimated:YES completion:block];
     }];
    [self presentViewController:tabVC animated:YES completion:nil];
}

- (void)userDeletedTabConfiguration:(BrowserTabConfiguration* __nonnull)configuration
                         withCompletionHandler:(void (^_Nullable)(BOOL))completion;
{
    NSInteger idx = [[self tabs] indexOfObject:configuration];
    [NSException throwIfNSNotFound:idx];
    [[self tabs] removeObjectAtIndex:idx];
    [[self tableViewController] removedItemAtIndex:idx];
    [[self cacher] invalidateCacheForConfiguration:configuration];
    if (!completion) { return; }
    completion(YES);
}

// MARK: BrowserTabConfigurationChangeDelegate

- (void)changeDidOccurToConfiguration:(BrowserTabConfiguration*)configuration;
{
    NSInteger idx = [[self tabs] indexOfObject:configuration];
    [NSException throwIfNSNotFound:idx];
    [[self tabs] replaceObjectAtIndex:idx withObject:configuration];
    [[self tableViewController] reloadItemAtIndex:idx];
}

@end
