//
//  GetCitiesRequest.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 21.05.2024.
//

import Alamofire

struct GetCitiesRequest: APIRequestBody {
    let iso2: String
    
    var url: String {
        "https://api.countrystatecity.in/v1/countries/\(iso2)/cities"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: HTTPHeaders? {
        [
            "X-CSCAPI-KEY": GlobalDefinitions.countriesCitiesAPIKey
        ]
    }
}
