//
//  NativeLocalStorageBridge.m
//  nativeTemplate
//
//  Created by machine on 1/11/25.
//

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(NativeLocalStorage, NSObject)

RCT_EXTERN_METHOD(setItem:(NSString *)value key:(NSString *)key)
RCT_EXTERN_METHOD(getItem:(NSString *)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(removeItem:(NSString *)key)
RCT_EXTERN_METHOD(clear)

@end
