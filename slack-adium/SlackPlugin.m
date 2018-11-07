//
//  SlackPlugin.m
//  slack-adium
//
//  Created by Tim Steiner on 2018-03-16.
//  Copyright © 2018 University of Nebraska-Lincoln. All rights reserved.
//

#import "SlackPlugin.h"
#import "SlackService.h"
#import <Adium/ESDebugAILog.h>
#import <libpurple/plugin.h>

extern gboolean purple_init_slack_plugin(void);

@implementation SlackPlugin

- (void)installPlugin {
    AIEnableDebugLogging();
    purple_init_slack_plugin();
    [SlackService registerService];
}

- (void)uninstallPlugin {
}

- (void)installLibpurplePlugin {
}

- (void)loadLibpurplePlugin {
}

@end
