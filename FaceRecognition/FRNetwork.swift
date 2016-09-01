//
//  FRNetwork.swift
//  FaceRecognition
//
//  Created by Joggy on 16/6/4.
//  Copyright © 2016年 Joggy. All rights reserved.
//

import UIKit

class FRNetwork: NSObject {

    class func postManager() -> AFHTTPSessionManager {
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/html") as? Set<String>
        return manager
    }
    
    class func getTrainSearchURL() -> String {
        return "https://apicn.faceplusplus.com/v2/train/search"
    }
    
    class func getRecognitionSearchURL() -> String {
        return "https://apicn.faceplusplus.com/v2/recognition/search"
    }
    
    class func getFacesetAddFaceURL() -> String {
        return "https://apicn.faceplusplus.com/v2/faceset/add_face"
    }
    
}
