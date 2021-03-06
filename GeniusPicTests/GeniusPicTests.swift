//
//  GeniusPicTests.swift
//  GeniusPicTests
//
//  Created by shiweifu on 16/7/10.
//  Copyright © 2016年 shiweifu. All rights reserved.
//

import XCTest
@testable import GeniusPic

class GeniusPicTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBase64() {
      let s = "hello world"
      let plainData = s.dataUsingEncoding(NSUTF8StringEncoding)!
      let result = plainData.base64()
      XCTAssertEqual("aGVsbG8gd29ybGQ=", result)
    }
  
    func testUploadLeanCloud() {
      
      let setting = NSApplication.readPlistWithResource("Setting")
      
      let leanCloudID  = setting!["LeanCloudID"]!
      let leanCloudKey = setting!["LeanCloudKey"]!
      
      let ex=expectationWithDescription("测试过滤关键字")
      let jsonCallback: DPRCallback = {(obj) in
        print(obj)
        ex.fulfill()
      }
      
      let img = NSImage(named: "pic")!
      
      let url = "https://api.leancloud.cn/1.1/files/any.jpg"

      let req = DPRequest(url:url, method: .POST, parseType: .JSON, callback:jsonCallback)
      req.httpHeaders["Content-Type"] = "image/jpeg"
      req.httpHeaders["X-LC-Id"]  = leanCloudID
      req.httpHeaders["X-LC-Key"] = leanCloudKey
      
      req.postData = img.imageJPEGRepresentation
      req.startAsync()
      
      waitForExpectationsWithTimeout(100) {error in
        if let error = error {
          print("got an error creating the request: \(error)")
        }
        else {
          print("访问数据逻辑测试通过")
        }
      }
    }
  
//  必须有设置文件
    func testReadPlist() {
      if let setting = NSApplication.readPlistWithResource("Setting") {
        XCTAssert(setting["LeanCloudID"]  != nil, "LeanCloudID没找到")
        XCTAssert(setting["LeanCloudKey"] != nil, "LeanCloudKey没找到")
      }
      else {
        XCTAssert(false, "读取设置文件失败")
      }
      
      
      
//      let leanCloudID = setting["leanCloudID"]
//      let leanCloudID = setting["leanCloudKey"]
      
    }
  
    func testUpload() {
      let url = "http://www.yotuku.cn/cgi-bin/upload/auto?name=&type=image/png"
      let b64 = "iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAMAAABFaP0WAAAADFBMVEX5wZz5wJv5w5z5wZue1giuAAAADklEQVQI12NgYGRgYgYAABEABy6Jt18AAAAASUVORK5CYII="
      let cookieValue = "42281522-1468159555-%7C1468159555"
      let cookieName  = "CNZZDATA1254721230"
      let cookieURL   = NSURL(string: "http://www.yotuku.cn")

      let ex=expectationWithDescription("测试过滤关键字")
      
      let jsonCallback: DPRCallback = {(obj) in
        print(obj)
        ex.fulfill()
      }
      
      let req = DPRequest(url:url, method: .POST, parseType: .JSON, callback:jsonCallback)
      req.addCookieWithName(cookieName, value: cookieValue, url: cookieURL!)
      req.postData = b64.utf8_data()
      req.httpHeaders["Content-Type"] = "text/plain"
      
      req.startAsync()
      
      waitForExpectationsWithTimeout(10) {error in
        if let error = error {
          print("got an error creating the request: \(error)")
        }
        else {
          print("访问数据逻辑测试通过")
        }
      }
    }
  
    func testStrToData() {
      XCTAssert("hello world".utf8_data() != nil)
    }
  
    func testGet() {
      
      let url = "http://news-at.zhihu.com/api/4/stories/latest"
      let ex=expectationWithDescription("测试过滤关键字");
      
      let jsonCallback: DPRCallback = {(obj) in
        print(obj)
        ex.fulfill()
      }
      
      let req = DPRequest(url:url, method: .GET, parseType: .JSON, callback:jsonCallback)
      req.startAsync()
      
      waitForExpectationsWithTimeout(10) {error in
          if let error = error {
          print("got an error creating the request: \(error)")
        }
        else {
          print("访问数据逻辑测试通过")
        }
      }

    }
}
