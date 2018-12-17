//
//  WeatherForecastController.swift
//  Weather5
//
//  Created by Dmitry Belyaev on 17/12/2018.
//  Copyright © 2018 Dmitry Belyaev. All rights reserved.
//

import UIKit

class WeatherForecastController: UIViewController {

    
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var imageView3: UIImageView!
    @IBOutlet var imageView4: UIImageView!
    @IBOutlet var imageView5: UIImageView!
    @IBOutlet var imageView6: UIImageView!
    @IBOutlet var imageView7: UIImageView!
    
    
    @IBOutlet var textView1: UILabel!
    @IBOutlet var textView2: UILabel!
    @IBOutlet var textView3: UILabel!
    @IBOutlet var textView4: UILabel!
    @IBOutlet var textView5: UILabel!
    @IBOutlet var textView6: UILabel!
    @IBOutlet var textView7: UILabel!
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "gradient.jpg")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)

    }
    

}
