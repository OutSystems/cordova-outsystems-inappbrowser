import OSInAppBrowserLib
import UIKit

/// The plugin's main class
@objc(OSInAppBrowser)
class OSInAppBrowser: CDVPlugin {
    /// The navite library's main class
    private var plugin: OSIABEngine?
    
    override func pluginInitialize() {
        self.plugin = .init(application: .shared)
    }
    
    @objc(openInExternalBrowser:)
    func openInExternalBrowser(command: CDVInvokedUrlCommand) {
        guard let url = command.arguments.first as? String else {
            self.send(error: .inputArgumentsIssue(target: .openInExternalBrowser), for: command.callbackId)
            return
        }
        
        self.commandDelegate.run { [weak self] in
            if self?.plugin?.openExternalBrowser(url) == true {
                self?.sendSuccess(for: command.callbackId)
            } else {
                self?.send(error: .openExternalBrowserFailed, for: command.callbackId)
            }
        }
    }

    @objc(coolMethod:)
    func coolMethod(command: CDVInvokedUrlCommand) {
        //TODO
    }
}

private extension OSInAppBrowser {
    func sendSuccess(for callbackId: String) {
        let pluginResult = CDVPluginResult(status: .ok)
        self.commandDelegate.send(pluginResult, callbackId: callbackId)
    }
    
    func send(error: OSInAppBrowserError, for callbackId: String) {
        let pluginResult = CDVPluginResult(status: .error, messageAs: error.toDictionary())
        self.commandDelegate.send(pluginResult, callbackId: callbackId)
    }
}
