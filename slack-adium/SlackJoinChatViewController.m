//
//  SlackJoinChatViewController.m
//  slack-adium
//
//  Created by Tim Steiner on 2018-03-20.
//  Copyright © 2018 University of Nebraska-Lincoln. All rights reserved.
//

#import "SlackJoinChatViewController.h"
#import "CBSlackAccount.h"
#import <Adium/ESDebugAILog.h>
#import <AdiumLibPurple/CBPurpleAccount.h>
#import <Adium/DCJoinChatWindowController.h>
#import <Adium/AISharedAdium.h>
#import <Adium/AIContactControllerProtocol.h>
#import <roomlist.h>

@implementation SlackJoinChatViewController

struct _PurpleRoomlist *room_list;
NSTimer *room_list_load_timer;

- (NSString *) nibName {
    return @"SlackJoinChatView";
}

- (void) configureForAccount:(AIAccount *)inAccount {
    [super configureForAccount:inAccount];
    
    CBPurpleAccount *account = (CBPurpleAccount *) inAccount;
    room_list = purple_roomlist_get_list(account.purpleAccount->gc);
    if (room_list) {
        purple_roomlist_ref(room_list);
        room_list_load_timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                                target:self
                                                              selector:@selector(roomListCallback:)
                                                              userInfo:nil
                                                               repeats:YES];
    }
}

- (void) dealloc {
    if (room_list_load_timer) {
        [room_list_load_timer invalidate];
        room_list_load_timer = NULL;
    }
    if (room_list) {
        purple_roomlist_unref(room_list);
        room_list = NULL;
    }
}

- (void) roomListCallback:(NSTimer *) timer {
    if (!room_list) {
        [timer invalidate];
        return;
    }
    
    if (purple_roomlist_get_in_progress(room_list) == TRUE) {
        return;
    }
    
    int expanded_rooms = 0;
    for (GList *rooms = room_list->rooms; rooms != NULL; rooms = rooms->next) {
        PurpleRoomlistRoom *room = rooms->data;
        if (room->type == PURPLE_ROOMLIST_ROOMTYPE_CATEGORY && !room->expanded_once) {
            purple_roomlist_expand_category(room_list, room);
            room->expanded_once = TRUE;
            expanded_rooms++;
        }
    }
    
    if (expanded_rooms > 0) {
        return;
    }
    
    [room_browser reloadColumn:0];
    
    [timer invalidate];
}

- (void)joinChatWithAccount:(AIAccount *)inAccount {
    PurpleRoomlistRoom *room = [(NSValue *) [room_browser itemAtIndexPath:[room_browser selectionIndexPath]] pointerValue];
    
    [self doJoinChatWithName:[NSString stringWithUTF8String:room->name]
                   onAccount:inAccount
            chatCreationInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithUTF8String:room->name], @"name", nil]
            invitingContacts:nil
       withInvitationMessage:nil];
}

- (NSInteger) browser:(NSBrowser *)browser numberOfChildrenOfItem:(id)item {
    NSLog(@"numberOfChildrenOfItem: %@", item);
    PurpleRoomlistRoom *parent_room = [(NSValue *)item pointerValue];
    
    int i = 0;
    for (GList *room = room_list->rooms; room != NULL; room = room->next) {
        PurpleRoomlistRoom *data = room->data;
        if (data->parent == parent_room) {
            i++;
        }
    }
    
    return i;
}

- (id) browser:(NSBrowser *)browser child:(NSInteger)index ofItem:(id)item {
    NSLog(@"childOfItem: %@[%li]", item, index);
    PurpleRoomlistRoom *parent_room = [(NSValue *)item pointerValue];
    
    int i = 0;
    for (GList *room = room_list->rooms; room != NULL; room = room->next) {
        PurpleRoomlistRoom *data = room->data;
        if (data->parent != parent_room) {
            continue;
        }
        if (i != index) {
            i++;
            continue;
        }
        return [NSValue valueWithPointer:room->data];
    }
    return [NSValue valueWithPointer:NULL];
}

- (BOOL)browser:(NSBrowser *)browser isLeafItem:(id)item {
    NSLog(@"isLeafItem: %@", item);
    PurpleRoomlistRoom *room = [(NSValue *)item pointerValue];
    if (room) {
        [(DCJoinChatWindowController *)delegate setJoinChatEnabled:YES];
        return room->type == PURPLE_ROOMLIST_ROOMTYPE_ROOM;
    } else {
        return YES;
    }
}

- (id)browser:(NSBrowser *)browser objectValueForItem:(id)item {
    NSLog(@"objectValueForItem: %@", item);
    PurpleRoomlistRoom *room = [(NSValue *)item pointerValue];
    if (room) {
        return [NSString stringWithUTF8String:room->name];
    } else {
        return @"NULL";
    }
}


@end
