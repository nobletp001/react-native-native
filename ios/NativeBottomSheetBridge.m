//
//  NativeBottomSheetBridge.m
//  nativeTemplate
//
//  Created by machine on 1/11/25.
//
// NativeBottomSheetBridge.m
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(NativeBottomSheet, NSObject)

RCT_EXTERN_METHOD(showBottomSheet:(NSDictionary *)config
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(dismissBottomSheet)

@end
