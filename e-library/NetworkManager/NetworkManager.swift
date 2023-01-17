//
//  RequestService.swift
//  Google Books
//
//  Created by Iskandar Fazliddinov on 01/01/23.
//

import Foundation
import SwiftyJSON

class NetworkManager {
    
    //MARK: - PROPERTIES
    
    private let baseURL = "https://www.googleapis.com/books/v1/volumes?q="
    private let key = "&key=AIzaSyBKa46XSgIMFMDobTkn3JrHT9vdN1II1Pk&download=epub"
    private let maxResults = "&maxResults=10&startIndex="
    var startIndex = 0
    static var shared = NetworkManager()
    
    //MARK: - METHODS
    
    func request(url: String, completion: @escaping (Result<SearchBaseModel, Error>) -> Void) {
        guard let searchingKey = url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: baseURL + "\(searchingKey)" + key + maxResults + "\(self.startIndex)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        print("🌎✅ \(request)")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse else { return }
            
            do {
                if response.statusCode == 200 {
                    let books = try JSONDecoder().decode(SearchBaseModel.self, from: data)
                    let prettyJson = try JSON(data: data)
                    print("🔽✅ \n\(prettyJson) \n ⬆️✅")
                    completion(.success(books))
                }
            } catch let JSONDecodeError {
                print("Ошибка с декодирование JSON файла: \(JSONDecodeError)")
                completion(.failure(JSONDecodeError))
            }
        }.resume()
        
    }
    
    func downloadImage(URLAddress: String, completion: @escaping ((UIImage?) -> Void)) {
        
        if let url = URL(string: URLAddress) {
            
            DispatchQueue.global(qos: .default).async {
                
                URLSession.shared.dataTask(with: url) {(data, response, error) in
                    
                    guard let data = data else { return }
                    
                    if let error = error {
                        print(error)
                    } else {
                        
                        let image = UIImage(data: data)
                        
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    }
                    
                }.resume()
            }
        }
    }
    
    func savePdf(urlString: String, fileName: String, completion: @escaping (Result<(), Error>) -> Void) {
        
            guard let url = URL(string: urlString) else { return}
            let pdfData = try? Data.init(contentsOf: url)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = "\(fileName).pdf"
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            
            do {
                guard let data = try pdfData?.write(to: actualPath, options: .atomic) else { return }
                print("📚 PDF SUCCESSFULLY SAVED IN: \(actualPath)")
                completion(.success(data))
            } catch {
                print("PDF COULD NOT BE SAVED")
                completion(.failure(error))
            }
        }
}

