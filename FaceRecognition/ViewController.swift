//
//  ViewController.swift
//  FaceRecognition
//
//  Created by Joggy on 16/6/4.
//  Copyright © 2016年 Joggy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var scroll: UIScrollView!
    var selectedImage: UIImageView!
    
    var labGuess: UILabel!
    var labGender: UILabel!
    var labAge: UILabel!
    var labSmiling: UILabel!
    var labNameGuess: UILabel!
    var labName: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        prepareForNav()
        prepareForLayout()
//        FRPersonList.addPersonAndFaceId("刘亦菲", id: "711e0760f03675d560bf6a4016d6ca1d")
    }
    
    func prepareForNav() {
        self.title = "人脸识别"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = FR_CustomBGColor
        self.navigationController?.navigationBar.translucent = false
        let leftButton = UIButton(type: UIButtonType.System)
        leftButton.frame = CGRectMake(0, 0, 44, 44)
        leftButton.setAttributedTitle(NSAttributedString(string: "Show", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(16)]), forState: UIControlState.Normal)
        leftButton.addTarget(self, action: #selector(selectAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        let rightButton = UIButton(type: UIButtonType.System)
        rightButton.frame = CGRectMake(0, 0, 44, 44)
        rightButton.setAttributedTitle(NSAttributedString(string: "Send", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(16)]), forState: UIControlState.Normal)
        rightButton.addTarget(self, action: #selector(sendToRecognition), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    func prepareForLayout() {
        let bgView = UIImageView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        bgView.image = UIImage(named: "fr_image_bg")
        bgView.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.addSubview(bgView)
        scroll = UIScrollView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        scroll.contentSize = CGSizeMake(scroll.frame.width, scroll.frame.height + 1)
        scroll.backgroundColor = UIColor.clearColor()
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        self.view.addSubview(scroll)
        selectedImage = UIImageView(frame: CGRectMake(0, 0, screenWidth, screenHeight/2))
        selectedImage.image = UIImage(named: "fr_image_holder")
        selectedImage.contentMode = UIViewContentMode.ScaleAspectFit
        scroll.addSubview(selectedImage)
        //识别信息
        labGuess = UILabel(frame: CGRectMake(40, screenHeight/2, screenWidth - 80, 18))
        labGuess.font = UIFont.systemFontOfSize(18)
        labGuess.textColor = FR_Info
        labGuess.textAlignment = NSTextAlignment.Right
        scroll.addSubview(labGuess)
        labGender = UILabel(frame: CGRectMake(40, screenHeight/2 + 28, screenWidth - 80, 18))
        labGender.font = UIFont.systemFontOfSize(18)
        labGender.textColor = FR_Info
        labGender.textAlignment = NSTextAlignment.Right
        scroll.addSubview(labGender)
        labAge = UILabel(frame: CGRectMake(40, screenHeight/2 + 28*2, screenWidth - 80, 18))
        labAge.font = UIFont.systemFontOfSize(18)
        labAge.textColor = FR_Info
        labAge.textAlignment = NSTextAlignment.Right
        scroll.addSubview(labAge)
        labSmiling = UILabel(frame: CGRectMake(40, screenHeight/2 + 28*3, screenWidth - 80, 18))
        labSmiling.font = UIFont.systemFontOfSize(18)
        labSmiling.textColor = FR_Info
        labSmiling.textAlignment = NSTextAlignment.Right
        scroll.addSubview(labSmiling)
        labNameGuess = UILabel(frame: CGRectMake(40, screenHeight/2 + 28*4, screenWidth - 80, 18))
        labNameGuess.font = UIFont.systemFontOfSize(18)
        labNameGuess.textColor = FR_Info
        labNameGuess.textAlignment = NSTextAlignment.Right
        scroll.addSubview(labNameGuess)
        labName = UILabel(frame: CGRectMake(40, screenHeight/2 + 28*5, screenWidth - 80, 18))
        labName.font = UIFont.systemFontOfSize(18)
        labName.textColor = FR_Info
        labName.textAlignment = NSTextAlignment.Right
        scroll.addSubview(labName)
    }
    
    func selectAction() {
        let action = UIAlertController(title: "请选择拍照或者从相册获取照片", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        action.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (alertAction) in
            print(alertAction.title)
        }))
        action.addAction(UIAlertAction(title: "相册", style: UIAlertActionStyle.Default, handler: { (alertAction) in
            print(alertAction.title)
            self.getFromAlbum()
        }))
        action.addAction(UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default, handler: { (alertAction) in
            print(alertAction.title)
            self.getByTakePicture()
        }))
        self.presentViewController(action, animated: true, completion: nil)
    }
    
    func getFromAlbum() {
        let photo = QYPhotos()
        photo.setBarItemColor(UIColor.whiteColor())
        photo.setBarTintColor(FR_CustomBGColor)
        photo.setSelectNumber(1)
        photo.delegate = self
        photo.showPhotos(self)
    }
    
    func getByTakePicture() {
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.delegate = self
        picker.allowsEditing = true
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func sendToRecognition() {
        ProgressHUD.show("正在识别中...")
        labGuess.text = "我猜猜..."
        labGender.text = ""
        labAge.text = ""
        labSmiling.text = ""
        labNameGuess.text = ""
        labName.text = ""
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            let imageToPlay = FROcFunc.fixOrientation(self.selectedImage.image!)
            let imageData = UIImageJPEGRepresentation(imageToPlay, 0.5)
            print(CGFloat(imageData!.length)/(1000.0*1000))
            let result = FaceppAPI.detection().detectWithURL(nil, orImageData: imageData)
            if result.success {
                delay(0, closure: {
                    ProgressHUD.dismiss()
                })
                let para = result.content!["face"] as! NSArray
                if para.count > 0 {
                    let para0 = para[0]
                    let para1 = para0["attribute"]
                    self.faceResult(para1 as! NSDictionary)
                    self.getName(para0["face_id"] as! String)
                }
                else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.labGender.text = "猜不出来了😔"
                    }
                }
            }
            else {
                delay(0, closure: {
                    ProgressHUD.dismiss()
                })
            }
        }
    }
    
    func faceResult(dic: NSDictionary) {
        print(dic)
        dispatch_async(dispatch_get_main_queue()) {
            self.labGender.text = self.getGender(dic["gender"]!["value"] as! String)
            self.labAge.text = self.getAge(Int((dic["age"]!["value"] as! NSNumber).intValue))
            self.labSmiling.text = self.getSmiling(Int((dic["smiling"]!["value"] as! NSNumber).intValue))
            self.labNameGuess.text = "你是..."
        }
    }
    
    func getGender(str: String) -> String {
        if str == "Female" {
            return "是个妹子"
        }
        else {
            return "是个汉子"
        }
    }
    
    func getAge(age: Int) -> String {
        if age < 15 {
            return "\(age)岁😱，这么年轻"
        }
        else {
            return "大概\(age)岁"
        }
    }

    func getSmiling(smile: Int) -> String {
        if smile > 60 {
            return "笑得好开心"
        }
        else {
            return "笑一下嘛，别那么严肃😄"
        }
    }
    
    func getName(str: String) {
        let manager1 = FRNetwork.postManager()
        let para1 = ["api_key": faceppKey, "api_secret": faceppSecret, "faceset_name": faceppSetName]
        manager1.POST(FRNetwork.getTrainSearchURL(), parameters: para1, progress: nil, success: { (dataTask, response) in
            let para2 = ["api_key": faceppKey, "api_secret": faceppSecret, "key_face_id": str, "faceset_name": faceppSetName, "count": "1"]
            let manager2 = FRNetwork.postManager()
            manager2.POST(FRNetwork.getRecognitionSearchURL(), parameters: para2, progress: nil, success: { (dataTask, response) in
                let dic = response!
                let dic2 = dic["candidate"]!
                let face_id = dic2![0]["face_id"] as! String
                let similarity = dic2![0]["similarity"] as! NSNumber
                print(dic)
                print(face_id)
                print(similarity)
                self.updateNameWithSimilarity(Int(similarity.intValue), withID: str, keyID: face_id)
                }, failure: { (dataTask, error) in
                    print(error)
            })
            }) { (dataTask, error) in
                print(error)
        }
    }
    
    func updateNameWithSimilarity(similarity: Int, withID id: String, keyID: String) {
        dispatch_async(dispatch_get_main_queue(), {
            if similarity > 55 {
                let nameStr = FRPersonList.getNameByFaceId(keyID)
                if nameStr == "还不认识呢" {
                    self.addPersionWithFaceId(id)
                }
                self.labName.text = nameStr
                
            }
            else {
                self.labName.text = "还不认识呢"
                self.addPersionWithFaceId(id)
            }
        })
    }
    
    func addPersionWithFaceId(id: String) {
        let knowAlert = UIAlertController(title: "还不认识呢", message: "认识一下吧", preferredStyle: UIAlertControllerStyle.Alert)
        let sureAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (alert) in
            let nameTextField = knowAlert.textFields![0] as UITextField
            if FRPersonList.addPersonAndFaceId(nameTextField.text!, id: id) {
                self.labName.text = nameTextField.text!
            }
        }
        let cancelActioin = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        knowAlert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "你的名字"
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification) in
                sureAction.enabled = textField != ""
            })
        }
        knowAlert.addAction(sureAction)
        knowAlert.addAction(cancelActioin)
        self.presentViewController(knowAlert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: QYPhotosDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func selectedPhotos(photos: [UIImage]) {
        selectedImage.image = photos[0]
        labGuess.text = ""
        labGender.text = ""
        labAge.text = ""
        labSmiling.text = ""
        labNameGuess.text = ""
        labName.text = ""
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        selectedImage.image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        labGuess.text = ""
        labGender.text = ""
        labAge.text = ""
        labSmiling.text = ""
        labNameGuess.text = ""
        labName.text = ""
    }
    
}

