//
//  EditViewController.swift
//  CameraSwiftReal
//
//  Created by Julie Lee on 2016/12/29.
//  Copyright © 2016年 JulieLee. All rights reserved.
//

import UIKit
import Social

class EditViewController: UIViewController {
    
     var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得

    override func viewDidLoad() {
        super.viewDidLoad()

        
    var Image = appDelegate.shareImage
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func TweetButton(sender: UIButton) {
        
        let text = "シェアしたい文章をココに入れてください"
        
        let composeViewController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
        composeViewController.setInitialText(text)
        
        self.present(composeViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func FacebookButton(sender: UIButton) {
        
        let text = "シェアしたい文章をココに入れてください"
        
        let composeViewController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
        composeViewController.setInitialText(text)
        
        self.present(composeViewController, animated: true, completion: nil)
    }
    
    

}
