//-------------------------------------------//

import UIKit

//-------------------------------------------//

class HostingAppViewController: UIViewController {
    
    @IBOutlet weak var logoContainerView: UIView!
    @IBOutlet weak var backgroundCenterConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 10.0,
                       delay: 0,
                       options: [.repeat, .autoreverse], animations: {
                        self.backgroundCenterConstraint.constant = 80.0
                        self.logoContainerView.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func openAliasButtonPressed(_ sender: Any) {
        UIApplication.shared.openURL(URL.init(string: "https://openalias.org/")!)
    }
    
    @IBAction func bansButtonPressed(_ sender: Any) {
        UIApplication.shared.openURL(URL.init(string: "https://github.com/hellc/bans-keyboard")!)
    }
}

//-------------------------------------------//

