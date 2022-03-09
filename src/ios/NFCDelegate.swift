import CoreNFC

@available(iOS 13.0, *)
class NFCDelegate: NSObject, NFCTagReaderSessionDelegate {
    
    var session: NFCTagReaderSession?
    var completed: ([AnyHashable : Any]?, Error?) -> ()
    
    init(completed: @escaping ([AnyHashable: Any]?, Error?) -> (), message: String?) {
        self.completed = completed
        super.init()
        self.session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        if (self.session == nil) {
            self.completed(nil, "NFC is not available" as? Error);
            return
        }
        self.session!.alertMessage = message ?? ""
        self.session!.begin()
    }
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("tagReaderSession")
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("tagReaderSession")
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        self.tagID = "00000000000000"
        if case NFCTag.iso7816(_) = tags.first! {
            print("NFCTag.iso7816")
        }

        if case let NFCTag.miFare(tag) = tags.first! {
            print("NFCTag.miFare")
            session.connect(to: tags.first!) {(error: Error?) in

                var tagID = ""
                tag.identifier.forEach {i in tagID.append(String(format: "%02X", i))}
                print(tagID)
                self.tagID = tagID;

                self.completed(nil,nil)
                session.invalidate();
            }
        }
    }
    
}

