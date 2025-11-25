//
//  NativeModule.m
//  MyRNFramework
//
//  Objective-C bridge to expose the Swift native module to React Native.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(NativeModule, NSObject)

RCT_EXTERN_METHOD(showNativeAlert:(NSString *)message)

RCT_EXTERN_METHOD(getDeviceInfo:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(triggerHapticFeedback:(NSString *)style)

RCT_EXTERN_METHOD(openURL:(NSString *)urlString
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

@end
