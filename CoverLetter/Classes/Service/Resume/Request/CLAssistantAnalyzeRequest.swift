//
//  CLAssistantAnalyzeRequest.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 31.08.2024.
//

import Alamofire

struct CLAssistantAnalyzeRequest: APIRequestBody {
    let qa: [[String: String]]
    let resumeStyle: String?
    
    var url: String {
        GlobalDefinitions.domain + "/api/v1/assistant/analyze"
    }
    
    var headers: HTTPHeaders? {
        [
            "Access-Token": GlobalDefinitions.apiKey
        ]
    }
    
    var parameters: Parameters? {
        var params: Parameters = [
            "user_data": qa
        ]
        
        if let resumeStyle {
            params["resume_style"] = resumeStyle
        }
        
        return params
    }
    
    var method: HTTPMethod {
        .post
    }
}
