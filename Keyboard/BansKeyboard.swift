//-------------------------------------------//

import UIKit

//-------------------------------------------//

/*
This is the demo keyboard. If you're implementing your own keyboard, simply follow the example here and then
set the name of your KeyboardViewController subclass in the Info.plist file.
*/

let kCatTypeEnabled = "kCatTypeEnabled"

class BansKeyboard: KeyboardViewController {
    
    var bansBanner: BansBanner!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        UserDefaults.standard.register(defaults: [kCatTypeEnabled: true])
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func keyPressed(_ key: Key) {
        let textDocumentProxy = self.textDocumentProxy

        let keyOutput = key.outputForCase(self.shiftState.uppercase())
        textDocumentProxy.insertText(keyOutput)
        
        if let before: String = textDocumentProxy.documentContextBeforeInput {
            performSearch(before)
        }
    }
    
    func performSearch(_ pattern: String) {
        bansBanner.clear()
        //TODO Do search
        
        var test = BansData()
        test.oa1 = "ada"
        test.recipientAddress = "Ae2tdPwUPEZ7f7RgToFi4EbUozdBNEYs34kRvSKPc33PUD93QUPT9JmxXwq"
        
        bansBanner.populate(with: [test, test, test]) { (selectedData: BansData!) in
            self.clearInput()
            self.textDocumentProxy.insertText(selectedData.recipientAddress!)
        }
    }
    
    func clearInput() {
        if (self.textDocumentProxy.documentContextBeforeInput != nil) {
            self.textDocumentProxy.deleteBackward()
            self.clearInput()
        }
    }
    
    override func setupKeys() {
        super.setupKeys()
    }
    
    override func createBanner() -> ExtraView? {
        bansBanner = BansBanner(globalColors: type(of: self).globalColors, darkMode: false, solidColorMode: self.solidColorMode())
        
        return bansBanner
    }
}

//-------------------------------------------//
