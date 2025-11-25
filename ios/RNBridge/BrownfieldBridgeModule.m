//
//  BrownfieldBridgeModule.m
//  React Native Brownfield Bridge
//
//  Objective-C bridge to expose the Swift native module to React Native.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(BrownfieldBridge, NSObject)

RCT_EXTERN_METHOD(navigateBack)
RCT_EXTERN_METHOD(onDataChange:(id)data)
RCT_EXTERN_METHOD(sendEvent:(NSString *)eventName body:(id)body)

@end
