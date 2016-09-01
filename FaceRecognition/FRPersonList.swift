//
//  FRPersonList.swift
//  FaceRecognition
//
//  Created by Joggy on 16/6/4.
//  Copyright © 2016年 Joggy. All rights reserved.
//

import UIKit

class FRPersonList: NSObject {
    
    class func getNameByFaceId(id: String) -> String {
        if isFileExist(personListPath) {
            let personList = NSDictionary(contentsOfFile: personListPath)!
            print(personList)
            if personList[id] == nil {
                return "还不认识呢"
            }
            else {
                return personList[id] as! String
            }
        }
        else {
            return "还不认识呢"
        }
    }
    
    class func addPersonAndFaceId(name: String, id: String) -> Bool {
        if isFileExist(personListPath) {
            let personList = NSMutableDictionary(contentsOfFile: personListPath)!
//            personList[id] = name
            personList.setValue(name, forKey: id)
            personList.writeToFile(personListPath, atomically: true)
            print(personList)
        }
        else {
            let personList = NSMutableDictionary()
//            personList[id] = name
            personList.setValue(name, forKey: id)
            personList.writeToFile(personListPath, atomically: true)
            print(personList)
        }
        let manager = FRNetwork.postManager()
        let para = ["api_key": faceppKey, "api_secret": faceppSecret, "faceset_name": faceppSetName, "face_id": id]
        manager.POST(FRNetwork.getFacesetAddFaceURL(), parameters: para, progress: nil, success: { (dataTask, response) in
            print(response)
            }) { (dataTask, error) in
                print(error)
        }
        return true
    }
    
}
