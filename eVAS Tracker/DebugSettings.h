//
//  DebugSettings.h
//  operamobile
//
//  Created by Brian on 1/18/20.
//  Copyright © 2020 samsotech. All rights reserved.
//

#import <Foundation/Foundation.h>

// TODO: use template pattern instead of macros
#define DEMO
#ifdef DEMO
  
    #define ENABLE_HAPPY_FLOW
   


#endif



// constants
extern BOOL const kDummyKeycardEnabled;
extern BOOL const kDebugHardcodeKeyImage;
extern BOOL const kEnableStaticKeyImageOption;
extern BOOL const kEnableRoomUpsellLink;
extern BOOL const kDebugSimulatorMode;
extern BOOL const kScanUsingRegula;
extern BOOL const kEnableIndependentVicasService;
extern float const STMDebugServiceDelay;

NS_ASSUME_NONNULL_BEGIN

/// DebugSettings
@interface DebugSettings : NSObject

@end


NS_ASSUME_NONNULL_END
