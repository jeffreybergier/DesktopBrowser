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

@interface TabListViewController () <TabListTableViewControllerDelegate>

@property (weak, nonatomic) TabListTableViewController* tableViewController;
@property (nonatomic, strong) NSMutableArray<BrowserTabConfiguration*>* tabs;

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
                                                                        scale:2
                                                            javascriptEnabled:YES]];
    [[self tableViewController] addedItemAtIndex:[[self tabs] count] - 1];
}

// MARK: TabListTableViewControllerDelegate

- (void)userSelectedTabConfiguration:(BrowserTabConfiguration* __nonnull)configuration;
{

}

- (void)userDeletedTabConfigurationAtIndexPath:(NSIndexPath* __nonnull)indexPath
                         withCompletionHandler:(void (^_Nonnull)(BOOL)) completion;
{
    [[self tabs] removeObjectAtIndex:indexPath.row];
    [[self tableViewController] removedItemAtIndex:indexPath.row];
    completion(YES);
}

@end
