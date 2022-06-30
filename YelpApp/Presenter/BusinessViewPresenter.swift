//
//  BusinessViewPresenter.swift
//  YelpApp
//
//  Created by Bell on 2022-06-29.
//


import Foundation
import Alamofire

//protocol StationsViewPresenter {
//    init(view: StationsView)
//    func viewDidLoad()
//}

class ViewPresenter {
    
    weak var view: BusinessView?
    private var businesses:[Business]?
    
    
    required init(view: BusinessView) {
        self.view = view
    }
    
    // MARK: - Protocol methods
    func viewDidLoad() {
        print("View notifies the Presenter that it has loaded.")
        retrieveItems()
    }
    
    // MARK: - Private methods
    private func retrieveItems() {
        print("Presenter retrieves station from API")
        
        let headers = HTTPHeaders(["Authorization": "Bearer jqJWAk-7WYqlFHYYYPO1n1ZXmIX5HqyZa5ND8dY39W9t95N1-uaF7EWw0ws4NTSaTAO2D2qLXlG2HvYmF9sL-PMddInum1okvFA_O_Jov0t9x4A8RtXBcVMvIxq7YnYx"])
        
        let request = AF.request("https://api.yelp.com/v3/businesses/search?location=NYC", headers: headers)
        
        request.responseDecodable { (response: DataResponse<BusinessResults, AFError>) in
            switch response.result {
                case let .success(value):
                    self.view?.onBusinessRetrieval(businessList: value.businesses)
                    
                case let .failure(error):
                    print(error)
            }
        }
    }
        

//            print(response)
//            do {
//
////                if(response.result.isSuccess){
////                    let result = try JSONDecoder().decode(Business.self, from: response.data!)
////                    let stations: [Business] = [result]
////
////                }
//            } catch {
//                print(error)
//            }

//        }

        
//        let stations: [Station]? = self.stations?
//            .map { $0 }
//        view?.onStationsRetrieval(stations: stations ?? [])
//        view?.onStationsRetrieval(stations: [])

}

