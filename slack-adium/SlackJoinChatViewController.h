//
//  SlackJoinChatViewController.h
//  slack-adium
//
//  Created by Tim Steiner on 2018-03-20.
//  Copyright © 2018 University of Nebraska-Lincoln. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Adium/DCJoinChatViewController.h>
#import <AIUtilities/AITextFieldWithDraggingDelegate.h>

@interface SlackJoinChatViewController : DCJoinChatViewController <NSBrowserDelegate> {
    IBOutlet NSComboBox *combo_rooms;
    IBOutlet NSBrowser *room_browser;
}

@end
