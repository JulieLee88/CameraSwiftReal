//
//  CameraFrontViewController.swift
//  CameraSwiftReal
//
//  Created by Julie Lee on 2016/12/29.
//  Copyright © 2016年 JulieLee. All rights reserved.
//

import UIKit

import AVFoundation

@objc protocol FilterScrollViewDelegate2: UIScrollViewDelegate {
    func filterButtonTapped(_ button: UIButton)
}

class CameraFrontViewController: UIViewController {
    
    var mySession : AVCaptureSession!
    // デバイス.
    var myDevice : AVCaptureDevice!
    // 画像のアウトプット.
    var myImageOutput : AVCaptureStillImageOutput!
    
    //UIImageの宣言
    var filterImageArray: [UIImage?] = []
    
    
    //保存のやつ AppDelegateのインスタンスを取得
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    
    @IBOutlet var scrollView : UIScrollView!
    
    @IBOutlet var cameraview : UIView!
    
    @IBOutlet var filterimageview : UIImageView!
    
    let uiSlider : UISlider = UISlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        uiSlider.minimumValue = 0.4
        
        uiSlider.maximumValue = 1
        
        uiSlider.value = 0.65
        
        
        
        
        filterImageArray = [UIImage(named: "4'.png"),UIImage(named: "5.png"),UIImage(named: "6'.png"),UIImage(named: "8'.png"),UIImage(named: "9.png"),UIImage(named: "10.png"),UIImage(named: "11.png"),UIImage(named: "20.png"),UIImage(named: "21.png"),UIImage(named: "25'.png"),UIImage(named: "26'.png"),UIImage(named: "27.png"),UIImage(named: "28.png")]
        

        scrollView.contentSize = CGSize(width: CGFloat(60*filterImageArray.count), height: scrollView.frame.size.height)
        for i in 0..<filterImageArray.count {
            let button : UIButton = UIButton()
            button.frame = CGRect(x: CGFloat(60*i+10), y: 0, width: 50, height: 50)
            button.tag = i+1
            button.setBackgroundImage(filterImageArray[i], for: UIControlState())
            button.addTarget(self, action: #selector(ViewController.selectImage(_:)), for: .touchUpInside)
            scrollView.addSubview(button)
        }
        
        
        // セッションの作成.
        mySession = AVCaptureSession()
        
        // デバイス一覧の取得.
        let devices = AVCaptureDevice.devices()
        
        // バックカメラをmyDeviceに格納.
        for device in devices!{
            if((device as AnyObject).position == AVCaptureDevicePosition.front){
                myDevice = device as! AVCaptureDevice
            }
        }
        
        // フロントカメラからVideoInputを取得.
        let videoInput = (try! AVCaptureDeviceInput.init(device: myDevice))
        
        // セッションに追加.
        mySession.addInput(videoInput)
        
        // 出力先を生成.
        myImageOutput = AVCaptureStillImageOutput()
        
        // セッションに追加.
        mySession.addOutput(myImageOutput)
        
        // 画像を表示するレイヤーを生成.
        
        let myVideoLayer = AVCaptureVideoPreviewLayer(session: mySession)//AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: mySession)
        myVideoLayer?.frame = self.cameraview.bounds
        myVideoLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        //        previewLayer = AVCaptureVideoPreviewLayer(session: captureSesssion)
        //        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect // アスペクトフィット
        //        previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait // カメラの向き
        //
        //        cameraview.layer.addSublayer(previewLayer!)
        
        
        // Viewに追加.
        self.cameraview.layer.addSublayer(myVideoLayer!)
        
        // セッション開始.
        mySession.startRunning()
        
        
        
    }
   
    
    func selectImage(_ sender: AnyObject?) {
    filterimageview.image = filterImageArray[sender!.tag-1]
    }
    @IBAction func sliderValueChanged(sender: UISlider) {
        //        var currentValue = Int(sender.value)
        filterimageview.alpha =  CGFloat(sender.value)
    }
    
    
    // ボタンイベント.
    @IBAction func onClickMyButton(_ sender: UIButton){
        
        // ビデオ出力に接続.
        let myVideoConnection = myImageOutput.connection(withMediaType: AVMediaTypeVideo)
        
        // 接続から画像を取得.
        self.myImageOutput.captureStillImageAsynchronously(from: myVideoConnection, completionHandler: { (imageDataBuffer, error) -> Void in
            
            // 取得したImageのDataBufferをJpegに変換.
            let myImageData : Data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
            
            // JpegからUIIMageを作成.
            //カメラから取得した画像
            let myImage : UIImage = UIImage(data: myImageData)!
            
            //正方形にした後に合成
            UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, 0);
            
            //塗りつぶす領域を決める
            myImage.draw(in: self.view.frame)
            self.filterimageview.image?.draw(in: self.filterimageview.frame)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let saveImage : UIImage = self.cropImageToSquare(image!)!
            
            self.appDelegate.shareImage = saveImage

            
            // アルバムに追加.
            UIImageWriteToSavedPhotosAlbum(saveImage, self, nil, nil)
            
        })
    }
    
    func cropImageToSquare(_ image: UIImage) -> UIImage? {
        
        let scale = UIScreen.main.scale
        let scaleRect = CGRect(x: self.cameraview.frame.origin.x * scale, y: self.cameraview.frame.origin.y * scale, width: self .cameraview.frame.size.width * scale, height: self.cameraview.frame.size.height * scale)
        
        let cropCGImageRef = image.cgImage!.cropping(to: scaleRect);
        return UIImage(cgImage: cropCGImageRef!, scale: scale, orientation: .up);
        
    }
    
    @IBAction func Album(_ sender :AnyObject){
        pickImageFromLibrary()
    }
    
func pickImageFromLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let controller = UIImagePickerController()
            controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(controller, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    @IBAction func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
