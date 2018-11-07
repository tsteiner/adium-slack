//
//  SlackService.m
//  slack-adium
//
//  Created by Tim Steiner on 2018-03-16.
//  Copyright © 2018 University of Nebraska-Lincoln. All rights reserved.
//

#import "SlackService.h"
#import "CBSlackAccount.h"
#import "SlackAccountViewController.h"
#import "SlackJoinChatViewController.h"

#import <Adium/AIStatusControllerProtocol.h>
#import <Adium/AISharedAdium.h>
#import <AIUtilities/AIImageAdditions.h>

@implementation SlackService

- (Class)accountClass {
    return [CBSlackAccount class];
}

- (AIServiceImportance)serviceImportance { return AIServiceSecondary; }
- (NSString *) serviceCodeUniqueID       { return @"libpurple-slack"; }
- (NSString *) serviceID                 { return @"Slack"; }
- (NSString *) serviceClass              { return @"Slack"; }
- (NSString *) shortDescription          { return @"Slack"; }
- (NSString *) longDescription           { return @"Slack API"; }

/*- (AIAccountViewController *)accountViewController {
    return [SlackAccountViewController accountViewController];
}*/

-(DCJoinChatViewController *)joinChatView {
    return [SlackJoinChatViewController joinChatView];
}

- (BOOL) requiresPassword {
    return NO;
}

- (BOOL) canCreateGroupChats {
    return TRUE;
}

- (void) registerStatuses {
    [adium.statusController registerStatus:@"active"
                           withDescription:[adium.statusController localizedDescriptionForCoreStatusName:STATUS_NAME_AVAILABLE]
                                    ofType:AIAvailableStatusType
                                forService:self];
    
    [adium.statusController registerStatus:@"away"
                           withDescription:[adium.statusController localizedDescriptionForCoreStatusName:STATUS_NAME_AWAY]
                                    ofType:AIAwayStatusType
                                forService:self];
}

- (NSImage *)defaultServiceIconOfType:(AIServiceIconType)iconType {
    NSImage *baseImage = [NSImage imageNamed:@"slack" forClass:[self class]];
    
    if ((iconType == AIServiceIconSmall) || (iconType == AIServiceIconList)) {
        [baseImage setSize:NSMakeSize(16, 16)];
    }
    
    return baseImage;
}

@end
