import CoreNFC

extension AppDelegate {
    
    override open func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        NSLog("Extending UIApplicationDelegate")
        
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb else {
            return false
        }
        
        // Confirm that the NSUserActivity object contains a valid NDEF message.
        if #available(iOS 12.0, *) {
            let ndefMessage = userActivity.ndefMessagePayload
            guard ndefMessage.records.count > 0,
            ndefMessage.records[0].typeNameFormat != .empty else {
                return false
            }

            let nfcPluginInstance: NfcPlugin = self.viewController.getCommandInstance("NfcPlugin") as! NfcPlugin
            nfcPluginInstance.fireNdefEvent(ndefMessage)
            
            return true
        } else {
            return false
        }
    }
}
