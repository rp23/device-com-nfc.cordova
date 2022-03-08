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
        if case NFCTag.iso7816(_) = tags.first! {
            print("NFCTag.iso7816")
        }

        if case let NFCTag.miFare(tag) = tags.first! {
            print("NFCTag.miFare")
            session.connect(to: tags.first!) {(error: Error?) in
                
                let apdu = NFCISO7816APDU(instructionClass: 0, instructionCode: 0xB0, p1Parameter: 0, p2Parameter: 0, data: Data(), expectedResponseLength: 16)
                var tagID = ""

                tag.identifier.forEach {i in tagID.append(String(format: "%02X", i))}

                print(tagID)
  
                tag.sendMiFareISO7816Command(apdu) { (data, sw1, sw2, error) in
                }
            }
        }
    }
    
}

