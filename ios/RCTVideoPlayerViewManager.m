//
//  RCTVideoPlayerViewManager.m
//  nativeTemplate
//
//  Created by machine on 1/11/25.
//

// RCTVideoPlayerViewManager.m
#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(RCTVideoPlayerViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(uri, NSString)
RCT_EXPORT_VIEW_PROPERTY(paused, BOOL)
RCT_EXPORT_VIEW_PROPERTY(muted, BOOL)
RCT_EXPORT_VIEW_PROPERTY(volume, float)
RCT_EXPORT_VIEW_PROPERTY(resizeMode, NSString)
RCT_EXPORT_VIEW_PROPERTY(onVideoLoad, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onVideoProgress, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onVideoBuffer, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onVideoEnd, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onVideoError, RCTDirectEventBlock)

@end
