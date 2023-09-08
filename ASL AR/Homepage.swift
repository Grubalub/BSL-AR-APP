//
//  Homepage.swift
//  ASL AR
//
//  Created by Gabriel  Cowan on 08/08/2023.
//

import UIKit

class Homepage : UIViewController {
     
    @IBOutlet weak var playButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func playButton(_ sender: UIButton){
        self.performSegue(withIdentifier: "goToAR", sender: self)
    }
}
