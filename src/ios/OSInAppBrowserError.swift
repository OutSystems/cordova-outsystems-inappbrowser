enum OSInAppBrowserTarget {
    case openInExternalBrowser
}

enum OSInAppBrowserError: Error {
    case inputArgumentsIssue(target: OSInAppBrowserTarget)
    case openExternalBrowserFailed
    
    private var code: Int {
        var result: Int
        
        switch self {
        case .inputArgumentsIssue: result = 0
        case .openExternalBrowserFailed: result = 0
        }
        
        return result
    }
    
    private var description: String {
        var result: String
        
        switch self {
        case .inputArgumentsIssue: result = ""
        case .openExternalBrowserFailed: result = ""
        }
        
        return result
    }
    
    func toDictionary() -> [String: String] {
        [
            "code": "OS-PLUG-IABP-\(String(format: "%04d", self.code))",
            "message": self.description
        ]
    }   
}
