//
//  SelectViewController.swift
//  CameraSwift
//
//  Created by Julie Lee on 2016/10/07.
//  Copyright © 2016年 JulieLee. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Album(_ sender :AnyObject){
        pickImageFromLibrary()
    }
    func pressCameraRoll(_ sender: AnyObject) {
        
        pickImageFromLibrary()  //ライブラリから写真を選択する
        
    }
    func pickImageFromLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(controller, animated: true, completion: nil)
        }
        
        }
    
      
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
