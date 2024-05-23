import { AndroidAnimation, AndroidSystemBrowserOptions, AndroidViewStyle, AndroidWebViewOptions, DismissStyle, SystemBrowserOptions, ToolbarPosition, WebViewOptions, iOSAnimation, iOSSystemBrowserOptions, iOSViewStyle, iOSWebViewOptions } from "./definitions"

export const DefaultAndroidWebViewOptions: AndroidWebViewOptions = {
    allowZoom: false,
    hardwareBack: true,
    pauseMedia: true
}
  
export const DefaultiOSWebViewOptions: iOSWebViewOptions = {
    allowOverScroll: true,

    enableViewportScale: false,
    allowInLineMediaPlayback: false,
    keyboardDisplayRequiresUserAction: true,
    surpressIncrementalRendering: false,

    viewStyle: iOSViewStyle.PAGE_SHEET,
    animation: iOSAnimation.FLIP_HORIZONTAL
}

export const DefaultWebViewOptions: WebViewOptions = {
    showToolbar: true,
    showURL: false,

    clearCache: true,
    clearSessionCache: true,
    mediaPlaybackRequiresUserAction: false,

    closeButtonText: "Close",
    toolbarPosition: ToolbarPosition.TOP,

    showNavigationButtons: true,
    leftToRight: false,

    android: DefaultAndroidWebViewOptions,
    iOS: DefaultiOSWebViewOptions
}

export const DefaultiOSSystemBrowserOptions: iOSSystemBrowserOptions = {
    closeButtonText: DismissStyle.CLOSE,
    viewStyle: iOSViewStyle.PAGE_SHEET,
    animationEffect: iOSAnimation.FLIP_HORIZONTAL,
    enableBarsCollapsing: true,
    enableReadersMode: false
}


export const DefaultAndroidSystemBrowserOptions: AndroidSystemBrowserOptions = {
    showTitle: false,
    hideToolbarOnScroll: false,
    viewStyle: AndroidViewStyle.BOTTOM_SHEET,
    
    startAnimation: AndroidAnimation.FADE_IN,
    exitAnimation: AndroidAnimation.FADE_IN
}
   
export const DefaultSystemBrowserOptions: SystemBrowserOptions = {
    android: DefaultAndroidSystemBrowserOptions,
    iOS: DefaultiOSSystemBrowserOptions,
    clearCache: false,
    clearSessionCache: false,
    mediaPlaybackRequiresUserAction: false
}