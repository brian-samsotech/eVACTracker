//
//  DebugSettings.m
//  operamobile
//
//  Created by Brian on 1/18/20.
//  Copyright © 2020 samsotech. All rights reserved.
//

#import "DebugSettings.h"

@implementation DebugSettings

#ifdef USING_DUMMY_KEYCARD_2
BOOL const kDummyKeycardEnabled = YES;
#else
BOOL const kDummyKeycardEnabled = NO;
#endif

#ifdef DEBUG_HARDCODE_KEY_IMAGE
BOOL const kDebugHardcodeKeyImage = YES;
#else
BOOL const kDebugHardcodeKeyImage = NO;
#endif

#ifdef USING_REGULA
BOOL const kScanUsingRegula = YES;
#else
BOOL const kScanUsingRegula = NO;
#endif

#ifdef ENABLE_SIMULATOR_MODE
BOOL const kDebugSimulatorMode = YES;
#else
BOOL const kDebugSimulatorMode = NO;
#endif

BOOL const kEnableStaticKeyImageOption = NO;
BOOL const kEnableRoomUpsellLink = NO;
BOOL const kEnableIndependentVicasService = NO;
float const STMDebugServiceDelay = 0.5;

@end
