//
//  SlackAccount.m
//  slack-adium
//
//  Created by Tim Steiner on 2018-03-16.
//  Copyright © 2018 University of Nebraska-Lincoln. All rights reserved.
//

#import "CBSlackAccount.h"
#import <account.h>
#import <Adium/AIStatus.h>
#import <Adium/AIListContact.h>
#import <Adium/ESDebugAILog.h>
#import <Adium/AIContactControllerProtocol.h>
#import <Adium/AIChatControllerProtocol.h>
#import <Adium/AIContactList.h>
#import <Adium/AISharedAdium.h>
#import "slack.h"
#import "slack-channel.h"

@implementation CBSlackAccount

- (const char *)protocolPlugin {
    return "prpl-slack";
}

- (void) configurePurpleAccount {
    purple_account_set_string(account, "api_token", [password UTF8String]);
    purple_account_set_bool(account, "enable_avatar_download", TRUE);
    [super configurePurpleAccount];
}

- (const char *)purpleStatusIDForStatus:(AIStatus *)statusState arguments:(NSMutableDictionary *)arguments {
    switch (statusState.statusType) {
        case AIAvailableStatusType:
            return "active";
        case AIAwayStatusType:
            return "away";
        case AIOfflineStatusType:
            return "offline";
        case AIInvisibleStatusType:
            return "offline";
    }
}

- (void) didConnect {
    [super didConnect];
    
    for (AIChat *chat in [adium.chatController openChats]) {
        if ([chat account] != self) {
            continue;
        }
        AILog(@"foobart chat: %@", chat);
        [self openChat:chat];
    }
}

- (BOOL)openChat:(AIChat *)chat {
    [super openChat:chat];
    
    PurpleChat *pc = purple_blist_find_chat([self purpleAccount], [[chat name] UTF8String]);
    if (pc) {
        serv_join_chat([self purpleAccount]->gc, pc->components);
    }
    
    return YES;
}

@end
