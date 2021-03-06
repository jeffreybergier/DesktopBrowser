//
//  BrowserMenuSectionsAndRows.h
//  DesktopBrowser
//
//  Created by Jeffrey Bergier on 30/04/2018.
//  Copyright © 2018 Jeffrey Bergier. All rights reserved.
//

#import "NSException+DBR.h"

typedef NS_ENUM(NSInteger, BrowserMenuSection) {
    BrowserMenuSectionURL,
    BrowserMenuSectionScaleJS,
    BrowserMenuSectionHideClose,
};

static const NSInteger BrowserMenuSectionCount = 3;

typedef NS_ENUM(NSInteger, BrowserMenuSectionURLRow) {
    BrowserMenuSectionURLRowURL
};

static const NSInteger BrowserMenuSectionURLRowCount = 1;

typedef NS_ENUM(NSInteger, BrowserMenuSectionScaleJSRow) {
    BrowserMenuSectionScaleJSRowScale,
    BrowserMenuSectionScaleJSRowJavascript
};

static const NSInteger BrowserMenuSectionScaleJSRowCount = 2;

typedef NS_ENUM(NSInteger, BrowserMenuSectionHideCloseRow) {
    BrowserMenuSectionHideCloseRowHide,
    BrowserMenuSectionHideCloseRowClose
};

static const NSInteger BrowserMenuSectionHideCloseRowCount = 2;

static NSInteger browserMenuSectionRowCountForSection(BrowserMenuSection section)
{
    switch (section) {
        case BrowserMenuSectionURL:
            return BrowserMenuSectionURLRowCount;
        case BrowserMenuSectionScaleJS:
            return BrowserMenuSectionScaleJSRowCount;
        case BrowserMenuSectionHideClose:
            return BrowserMenuSectionHideCloseRowCount;
        default:
            [NSException throwIfNilObject:nil];
    }
}

static NSString* browserMenuSectionTitleForSection(BrowserMenuSection section)
{
    switch (section) {
        case BrowserMenuSectionURL:
            return @"Website URL";
        case BrowserMenuSectionScaleJS:
            return @"Browser Settings";
        case BrowserMenuSectionHideClose:
            return @"Manage Tab";
        default:
            [NSException throwIfNilObject:nil];
    }
}
