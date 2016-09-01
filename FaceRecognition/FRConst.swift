//
//  FRConst.swift
//  FaceRecognition
//
//  Created by Joggy on 16/6/4.
//  Copyright © 2016年 Joggy. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.mainScreen().bounds.width
let screenHeight = UIScreen.mainScreen().bounds.height

let faceppKey = "c2ac7bf45a332900e09623f92bbf0a77"
let faceppSecret = "7jEs5wNU-lDLn7CAhSszRmztJgBMVfl0"
let faceppSetName = "5a76bb5c0c1e427d8373cf0b6496e04d"

let personListPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentationDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] + "persionList.txt"

func delay(time: Double, closure: ()->()) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time*Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
}

func isFileExist(path: String) -> Bool {
    let manager = NSFileManager.defaultManager()
    return manager.fileExistsAtPath(path)
}



