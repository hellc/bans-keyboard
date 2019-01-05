//-------------------------------------------//

import UIKit

//-------------------------------------------//

class BansKeyboard: KeyboardViewController {
    
    var bansBanner: BansBanner!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupKeys() {
        super.setupKeys()
    }
    
    override func createBanner() -> ExtraView? {
        bansBanner = BansBanner(globalColors: type(of: self).globalColors, darkMode: false, solidColorMode: self.solidColorMode())
        
        return bansBanner
    }
    
    override func keyPressed(_ key: Key) {
        let keyOutput = key.outputForCase(self.shiftState.uppercase())
        self.textDocumentProxy.insertText(keyOutput)
        
        if let before: String = self.textDocumentProxy.documentContextBeforeInput {
            performSearch(before)
        }
    }
    
    override func backspaceDown(_ sender: KeyboardKey) {
        super.backspaceDown(sender)
        
        if let before: String = self.textDocumentProxy.documentContextBeforeInput {
            performSearch(before)
        }
    }
    
    func performSearch(_ pattern: String) {
        self.bansBanner.clear()
        
        self.performOASearch(pattern) { (bansRawData) in
            
            let array = NSMutableArray()
            
            for bansDataRawItem in bansRawData! {
                let bansDataItem = self.bansDataItem(from: bansDataRawItem as! String)
                if bansDataItem != nil {
                    array.add(bansDataItem!)
                }
            }
            
            self.bansBanner.populate(with: array) { (selectedData: BansData!) in
                self.clearInput()
                self.textDocumentProxy.insertText(selectedData.recipientAddress!)
            }
        }
    }
    
    func bansDataItem(from rawBansData: String) -> BansData? {
        let temp = rawBansData.split(separator: " ", maxSplits: 2, omittingEmptySubsequences: true)
        
        let symbolTemp = String(temp.first!)
        let symbolTemp2 = symbolTemp.split(separator: ":", maxSplits: 2, omittingEmptySubsequences: true)
        let symbol = String(symbolTemp2.last!)
        
        var address = ""
        for slice in temp {
            if slice.contains("recipient_address=") {
                let addressTemp = slice.split(separator: "=", maxSplits: 2, omittingEmptySubsequences: true)
                address = (String(addressTemp.first!) == "recipient_address" ? String(addressTemp.last!) : nil)!
                if address.hasSuffix(";") {
                    address = String(address.dropLast())
                }
            }
        }
        
        if (symbol.count > 0 && address.count > 0) {
            var bansDataItem: BansData = BansData()
            bansDataItem.oa1 = symbol
            bansDataItem.recipientAddress = address
            return bansDataItem
        }; return nil
    }
    
    func performOASearch(_ pattern: String, completion: ((_ bansRawData : NSArray?) -> Void)?) {
        if !pattern.contains(".") ||
            pattern.contains(" ") ||
            pattern.contains("\n") ||
            pattern.last == "." ||
            completion == nil {
            return
        }
        
        let basicEndpoint: String = "https://cloudflare-dns.com/dns-query?"
        let url = URL(string: "\(basicEndpoint)name=\(pattern)&type=TXT")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/dns-json", forHTTPHeaderField: "accept")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let json = try JSON(data: data)
                let array = NSMutableArray()
                
                for item in json["Answer"] {
                    let temp = item.1["data"].string!.replacingOccurrences(of: "\"", with: "") as String
                    if temp.hasPrefix("oa1:") {
                        array.add(temp)
                    }
                }
                
                completion!(array)
            } catch{
                print("Error info: \(error)")
                completion!(nil)
            }
        }
        
        task.resume()
    }
    
    func clearInput() {
        if let word:String = self.textDocumentProxy.documentContextBeforeInput {
            for _: Int in 0 ..< word.count {
                self.textDocumentProxy.deleteBackward()
            }
        }
    }
}

//-------------------------------------------//
