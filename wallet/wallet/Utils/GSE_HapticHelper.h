//
//  GSE_HapticHelper
//  wallet
//
//  Created by user on 20/09/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    FeedbackType_Selection,
    FeedbackType_Impact_Light,
    FeedbackType_Impact_Medium,
    FeedbackType_Impact_Heavy,
    FeedbackType_Notification_Success,
    FeedbackType_Notification_Warning,
    FeedbackType_Notification_Error
}FeedbackType;

@interface GSE_HapticHelper : NSObject

+ (void)generateFeedback:(FeedbackType)type;

@end
