import OSInAppBrowserLib
import UIKit

/// The plugin's main class
@objc(OSInAppBrowser)
class OSInAppBrowser: CDVPlugin {
    /// The native library's main class
    private var plugin: OSIABEngine<OSIABApplicationRouterAdapter, OSIABSafariViewControllerRouterAdapter>?
    
    private var currentlyOpenedBrowser: (any OSIABRouter)?
    
    override func pluginInitialize() {
        self.plugin = .init()
    }
    
    @objc(openInExternalBrowser:)
    func openInExternalBrowser(command: CDVInvokedUrlCommand) {
        let target = OSInAppBrowserTarget.openInExternalBrowser
        
        func delegateExternalBrowser(_ url: String, _ callbackId: String) {
            DispatchQueue.main.async {
                self.plugin?.openExternalBrowser(url, { [weak self] success in
                    guard let self else { return }
                    
                    if success {
                        self.send(eventType: .success, for: callbackId)
                    } else {
                        self.send(error: .failedToOpen(url: url, onTarget: target), for: callbackId)
                    }
                })
            }
        }
        
        self.commandDelegate.run { [weak self] in
            guard let self else { return }
            
            guard let argumentsModel: OSInAppBrowserInputArgumentsSimpleModel = self.createModel(for: command.argument(at: 0))
            else {
                return self.send(error: .inputArgumentsIssue(target: target), for: command.callbackId)
            }
            
            delegateExternalBrowser(argumentsModel.url, command.callbackId)
        }
    }
    
    @objc(openInSystemBrowser:)
    func openInSystemBrowser(command: CDVInvokedUrlCommand) {
        let target = OSInAppBrowserTarget.openInSystemBrowser
        
        func delegateSystemBrowser(_ url: String, _ options: OSIABSystemBrowserOptions, _ callbackId: String) {
            DispatchQueue.main.async {
                self.currentlyOpenedBrowser = self.plugin?.openSystemBrowser(url, options, { [weak self] event, safariViewController in
                    guard let self else { return }
                    
                    if event == .success {
                        if let safariViewController {
                            self.viewController.show(safariViewController, sender: nil)
                        } else {
                            self.send(error: .failedToOpen(url: url, onTarget: target), for: callbackId)
                        }
                    }
                    
                    self.send(eventType: event, for: callbackId)
                })
            }
        }
        
        self.commandDelegate.run { [weak self] in
            guard let self else { return }
            
            guard let argumentsModel: OSInAppBrowserInputArgumentsSystemBrowserModel = self.createModel(for: command.argument(at: 0))
            else {
                return self.send(error: .inputArgumentsIssue(target: target), for: command.callbackId)
            }
                        
            delegateSystemBrowser(argumentsModel.url, argumentsModel.toOptions(), command.callbackId)
        }
    }
    
    @objc(coolMethod:)
    func coolMethod(command: CDVInvokedUrlCommand) {
        //TODO
    }
}

private extension OSInAppBrowser {
    func createModel<T: Decodable>(for inputArgument: Any?) -> T? {
        guard let argumentsDictionary = inputArgument as? [String: Any],
              let argumentsData = try? JSONSerialization.data(withJSONObject: argumentsDictionary),
              let argumentsModel = try? JSONDecoder().decode(T.self, from: argumentsData)
        else { return nil }
        return argumentsModel
    }
    
    func send(eventType: OSIABEventType, for callbackId: String) {
        let pluginResult = CDVPluginResult(status: .ok, messageAs: eventType.rawValue)
        pluginResult?.keepCallback = true
        self.commandDelegate.send(pluginResult, callbackId: callbackId)
    }
    
    func send(error: OSInAppBrowserError, for callbackId: String) {
        let pluginResult = CDVPluginResult(status: .error, messageAs: error.toDictionary())
        self.commandDelegate.send(pluginResult, callbackId: callbackId)
    }
}

private extension OSIABEngine where ExternalBrowser == OSIABApplicationRouterAdapter {
    func openExternalBrowser(_ url: String, _ completionHandler: @escaping (Bool) -> Void) {
        let router = OSIABApplicationRouterAdapter(UIApplication.shared)
        self.openExternalBrowser(url, routerDelegate: router, completionHandler)
    }
}

private extension OSIABEngine where SystemBrowser == OSIABSafariViewControllerRouterAdapter {
    func openSystemBrowser(_ url: String, _ options: OSIABSystemBrowserOptions, _ completionHandler: @escaping (OSIABEventType, UIViewController?) -> Void) -> SystemBrowser {
        let router = OSIABSafariViewControllerRouterAdapter(
            options,
            onBrowserPageLoad: { completionHandler(.pageLoadCompleted, nil) },
            onBrowserClosed: { completionHandler(.pageClosed, nil) }
        )
        self.openSystemBrowser(url, routerDelegate: router) { completionHandler(.success, $0) }
        return router
    }
}

enum OSIABEventType: String {
    case success = "SUCCESS"
    case pageClosed = "PAGE_CLOSED"
    case pageLoadCompleted = "PAGE_COMPLETED"
}
