//
//  NFCNDEFDelegate.swift
//  IoTize Toolbox
//
//  Created by dev@iotize.com on 05/08/2019.
//

import Foundation
import CoreNFC

class NFCNDEFDelegate: NSObject, NFCNDEFReaderSessionDelegate {
    var session: NFCNDEFReaderSession?
    var completed: ([AnyHashable : Any]?, Error?) -> ()
    
    init(completed: @escaping ([AnyHashable: Any]?, Error?) -> (), message: String?) {
        self.completed = completed
        super.init()
        self.session = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        self.session!.alertMessage = message ?? ""
        self.session!.begin()
    }
    
    func readerSession(_: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            self.fireNdefEvent(message: message)
        }
        self.session?.invalidate()
    }
    
    func readerSession(_: NFCNDEFReaderSession, didInvalidateWithError _: Error) {
        completed(nil, "NFCNDEFReaderSession error" as? Error)
    }

    func readerSessionDidBecomeActive(_: NFCNDEFReaderSession) {
        print("NDEF Reader session active")
    }
    
    func fireNdefEvent(message: NFCNDEFMessage) {
        let response = self.ndefMessageToJSON(message: message)
        completed(response, nil)
    }
    

    func ndefMessageToJSON(message: NFCNDEFMessage) -> [AnyHashable: Any] {
        let array = NSMutableArray()
        for record in message.records {
            let recordDictionary = self.ndefToNSDictionary(record: record)
            array.add(recordDictionary)
        }
        let wrapper = NSMutableDictionary()
        wrapper.setObject(array, forKey: "ndefMessage" as NSString)
//        return self.dictionaryAsJSONString(dictionary: wrapper)
        return wrapper as! [AnyHashable : Any]
    }
    
    func ndefToNSDictionary(record: NFCNDEFPayload) -> NSDictionary {
        let dict = NSMutableDictionary()
        dict.setObject([record.typeNameFormat.rawValue], forKey: "tnf" as NSString)
        dict.setObject([UInt8](record.type), forKey: "type" as NSString)
        dict.setObject([UInt8](record.identifier), forKey: "id" as NSString)
        dict.setObject([UInt8](record.payload), forKey: "payload" as NSString)
        
        return dict
    }
    
    func dictionaryAsJSONString(dictionary: NSMutableDictionary) -> NSString {
        var json: Data
        var jsonString: NSString
        do {
            try json = JSONSerialization.data(withJSONObject: dictionary)
            jsonString = NSString.init(data: json, encoding: String.Encoding.utf8.rawValue)!
        } catch {
            print("\(error)")
            jsonString = NSString.localizedStringWithFormat("Error creating JSON for NDEF Message, \(error)" as NSString)
        }
        
        return jsonString
    }
}
