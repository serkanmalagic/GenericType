//
//  ViewController.swift
//  GenericType
//
//  Created by Serkan Mehmet Malagiç on 23.09.2021.
//
//  İlgili proje gerekli json cevabından istenen değişkenler dışında bir yapı olduğunda çalışmaya devam eden generic type değişke tipini kullanır

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  sendModelRequest()
        sendGenericRequest()
        
    }
    
    func sendModelRequest(){
        // Gönderilen ve gelen model bellidir. Model yanlış olduğunda hata dönecektir
        fetchHomeFeed(urlString: "https://api.letsbuildthatapp.com/youtube/home_feed")  { (homeFeed) in
            homeFeed.videos.forEach({print($0.name)})
        }
        fetchHomeFeed(urlString: "https://api.letsbuildthatapp.com/youtube/course_detail?id=1")  { (homeFeed) in
            homeFeed.videos.forEach({print($0.name)})
        }
       
        fetchHomeFeed(urlString: "https://api.letsbuildthatapp.com/jsondecodable/courses")  { (homeFeed) in
            homeFeed.videos.forEach({print($0.name)})
        }
    }
    
    func sendGenericRequest(){
        
        fetchGenericData(urlString: "https://api.letsbuildthatapp.com/youtube/home_feed") { (homeFeed: HomeFeed) in
            homeFeed.videos.forEach({print($0.name)})
        }
        
        fetchGenericData(urlString: "https://api.letsbuildthatapp.com/youtube/course_detail?id=1") { (courseDetails: [CourseDetail]) in
            courseDetails.forEach({print($0.name, $0.duration)})
        }
         
    }
    
    //  Sıradan çinko karbon piller
    fileprivate func fetchHomeFeed( urlString: String, completion: @escaping ( HomeFeed ) -> ()) {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!){ ( data, resp, err ) in
            guard let data = data else { return }
            
            do {
                let homeFeed = try JSONDecoder().decode( HomeFeed.self, from: data )
                completion(homeFeed)
            }catch let jsonErr {
                print("failed to decode json : ", jsonErr)
            }
        }.resume()
    }
    
    
    //  GenericCell
    fileprivate func fetchGenericData<T: Decodable>(urlString: String, completion: @escaping (T) -> ()) {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, resp, err) in
            
            if let err = err {
                print("Failed to fetch data:", err)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let obj = try JSONDecoder().decode(T.self, from: data)
                completion(obj)
            } catch let jsonErr {
                print("Failed to decode json:", jsonErr)
            }
        }.resume()
    }
    

}

struct CourseDetail: Decodable {
    let name: String
    let duration: String
}

struct HomeFeed: Decodable {
    let videos: [Video]
}

struct Video: Decodable {
    let id: Int
    let name: String
}
