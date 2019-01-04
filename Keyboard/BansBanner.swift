//-------------------------------------------//

import UIKit

//-------------------------------------------//

class BansBanner: ExtraView {
    
    let offset = CGFloat(10.0)
    
    var scrollView: UIScrollView! = UIScrollView()
    var stackView: UIStackView! = UIStackView()
    
    required init(globalColors: GlobalColors.Type?, darkMode: Bool, solidColorMode: Bool) {
        super.init(globalColors: globalColors, darkMode: darkMode, solidColorMode: solidColorMode)
        
        self.scrollView.bounces = true
        self.scrollView.isScrollEnabled = true
        self.stackView.spacing = offset
        
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.stackView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.frame = self.frame
    }
    
    func updateAppearance() {
        var width = CGFloat(0.0)
        for subview in self.stackView.subviews {
            width += CGFloat(subview.frame.size.width) + self.offset
        }
        
        self.stackView.frame = CGRect(x: self.offset / 2,
                                      y: self.offset / 2,
                                      width: width,
                                      height: self.frame.size.height - self.offset)
        self.scrollView.contentSize = CGSize(width: width + self.offset, height: self.frame.size.height)
    }
    
    func clear() {
        for subview in self.stackView.subviews {
            subview.removeFromSuperview()
        }
        
        self.updateAppearance()
    }
    
    var completionBlock: ((_ selectedData : BansData?) -> Void)?
    func populate(with data: NSArray, completion: ((_ selectedData : BansData?) -> Void)?) {
        DispatchQueue.main.async {
            self.clear()
            
            if (completion != nil) {
                self.completionBlock = completion
            }
            
            for item in data {
                let bansDataItem = item as! BansData
                
                let button = self.button(for: bansDataItem)
                
                button.addAction {
                    self.clear()
                    
                    if (self.completionBlock != nil) {
                        self.completionBlock!(bansDataItem)
                    }
                }
                
                self.stackView.addArrangedSubview(button)
            }
            
            self.updateAppearance()
        }
    }
    
    func button(for bansData: BansData) -> UIButton {
        let button = UIButton()
        button.setTitle(String(format: " %@:%@ ", bansData.oa1!.uppercased(), bansData.recipientAddress!), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10.0)
        
        button.sizeToFit()
        
        button.backgroundColor = UIColor.init(hue: 0.0, saturation: 0.0, brightness: 0.5, alpha: 0.3)
        
        button.setBackgroundImage(nil, for: .normal)
        button.layer.cornerRadius = 4.0
        button.layer.masksToBounds = true
        button.setTitleColor(self.darkMode ? .white : .darkGray, for: .normal)
        
        button.layoutIfNeeded()
        
        return button
    }
}

//-------------------------------------------//

