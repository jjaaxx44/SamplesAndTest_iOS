//
//  ViewController.swift
//  JsonParsing
//
//  Created by Abhishek Chaudhari on 16/08/18.
//  Copyright © 2018 Abhishek Chaudhari. All rights reserved.
//

//[
//    {
//        id: 1,
//        name: "Instagram Firebase",
//        link: "https://www.letsbuildthatapp.com/course/instagram-firebase",
//        imageUrl: "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/04782e30-d72a-4917-9d7a-c862226e0a93",
//        number_of_lessons: 49
//    },
//    2 more cource
//]

import UIKit

struct Course: Decodable {
    //variable should be same as key in json
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    let numberOfLessons: Int?

    //for keys not similar to jaon
    private enum CodingKeys: String, CodingKey{
        case numberOfLessons = "number_of_lessons"
        case id, name, link, imageUrl
    }
    
    //Used only for old way of parsing
    init(json: [String: Any]) {
        id = json["id"] as? Int ?? -1
        name = json["name"] as? String ?? ""
        link = json["link"] as? String ?? ""
        imageUrl = json["imageUrl"] as? String ?? ""
        numberOfLessons = json["number_of_lessons"] as? Int ?? -1
    }
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let jsonUrlString = URL(string: "https://api.letsbuildthatapp.com/jsondecodable/courses_missing_fields") else {
            return
        }
        
        URLSession.shared.dataTask(with: jsonUrlString) { (data, response, err) in
            if (err != nil) {
                print(err!)
            }
            guard let data = data else { return }
            self.oldWayOfParsing(data: data)
            self.newWayOfParsing(data: data)
            }.resume()
    }
    
    func newWayOfParsing(data: Data){ //swift 4+
        print("***New way of parsing***")

        do {
            let courses = try JSONDecoder().decode([Course].self, from: data)
            for course in courses{
                print("\(course.name ?? "") \(course.numberOfLessons ?? -1)")
            }

        }catch let err {
            print(err)
        }
    }
    
    func oldWayOfParsing(data: Data) {  //swift 2,3 and obj-c
        print("***Old way of parsing***")

        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else{
                return
            }
            for courseJson in json{
                let course = Course(json: courseJson)
                print("\(course.name ?? "") \(course.numberOfLessons ?? -1)")
            }
        } catch let err {
            print(err)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

