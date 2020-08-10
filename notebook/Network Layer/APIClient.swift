//
//  APIClient.swift
//  notebook
//
//  Created by Abdorahman Youssef on 1/29/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Alamofire
import Log
import ObjectMapper

typealias Success = (Mappable) -> Void
typealias Failure = (Error?) -> Void

struct ResponseKeys {
    static var responseContentKey: String = "content"
}

protocol APIClient {
    var baseUrl: String { get }
    var errorModel: Convertable { get }
    var validStatusCodes: [Int] { get }
    var headers: [String: String]? { get }
    func start<T: Mappable>(request: Request, model: T, success: @escaping Success, failure: @escaping Failure)
    func checkNetworkState() -> Bool
}

extension APIClient {
    func start<T: Mappable>(request: Request, model: T, success: @escaping Success, failure: @escaping Failure) {
        var fullUrl: String = request.path
        if !fullUrl.contains(baseUrl){
            fullUrl = "\(baseUrl)\(fullUrl)"
        }
        fullUrl = fullUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? fullUrl
        var headerPerRequest = headers
        
        guard checkNetworkState() else {
            let error: NBErrorCase = NBErrorCase.noInternetConnection
            failure(error)
            return
        }
        
        if request.headers != nil {
            for header in request.headers! {
                headerPerRequest?[header.key] = header.value
            }
        }
        
        var encode: ParameterEncoding
        switch request.method {
        case HTTPMethod.get:
            encode = URLEncoding(destination: .queryString)
        default:
            encode = JSONEncoding.default
        }
        NSLogv("Full Url :- %@   parameters:- %@  headers:- %@  method:- %@  path: %@", getVaList([fullUrl, String(describing: request.parameters).replacingOccurrences(of: "\n", with: " ") , String(describing: headerPerRequest).replacingOccurrences(of: "\n", with: " ") , String(describing: request.method.rawValue).replacingOccurrences(of: "\n", with: " "), String(describing: request.path).replacingOccurrences(of: "\n", with: " ")]))
        
        Alamofire.SessionManager.default.request(fullUrl, method: request.method,
                                                 parameters: request.parameters,
                                                 encoding: encode,
                                                 headers: headerPerRequest,
                                                 cachePolicy: request.cachePolicy)
            .validate(statusCode: validStatusCodes)
            .responseJSON { response in
                
//                if let token = response.response?.allHeaderFields["authorization"] as? String {
//                    Logger().debug("Token : \(token)")
////                    LocalStore.save(token: token)
//                }
                
                NSLogv("Response Log is header:-  %@  value:- %@", getVaList([String(describing: response.response?.allHeaderFields).replacingOccurrences(of: "\n", with: " ") , String(describing: response.result).replacingOccurrences(of: "\n", with: " ") ]))
                
                if (response.request?.httpMethod?.lowercased().elementsEqual("post") ?? false) || (response.request?.httpMethod?.lowercased().elementsEqual("put") ?? false) {
                    Logger().debug("++ response Log is request url: \(response.request?.url?.absoluteString ?? "url string")\n\n resquest method \(response.request?.httpMethod ?? "http method")\n\n request headers: \(response.request?.allHTTPHeaderFields ?? ["header": "test"]) \n\nrequest parameters: \(String(data: (response.request?.httpBody)!, encoding: .utf8) ?? "body")\n\n response value: \(String(data: response.data!, encoding: .utf8) ?? "data") \n\n response headers: \(response.response?.allHeaderFields ?? ["header": "test"])")
                } else {
                    Logger().debug("++ response Log is request url: \(response.request?.url?.absoluteString ?? "url")\n\n resquest method \(response.request?.httpMethod ?? "http method")\n\n request headers: \(response.request?.allHTTPHeaderFields ?? ["header": "test"]) \n\n response value: \(String(data: response.data!, encoding: .utf8) ?? "data") \n\n response headers: \(response.response?.allHeaderFields ?? ["header": "test"])")
                }
                
                if let error = response.result.error {
                    Logger().debug(error as Any)
                } else {
                    Logger().debug(response.result.value as Any)
                    NSLogv("Value:- %@", getVaList([String(describing: response.result.value).replacingOccurrences(of: "\n", with: " ") ]))
                }
                
                response.mapResult(model: model, errorModel: self.errorModel, success: success, failure: failure)
        }
    }
    
    func checkNetworkState() -> Bool {
        
        return NetworkReachabilityManager()!.isReachable
    }
}

extension DataResponse {
    
    func mapResult<T: Mappable>(model: T, errorModel: Convertable, success: @escaping Success, failure: @escaping Failure) {
        switch result {
        case let .success(response):
            if let jsonObject = response as? [String: Any] {
                let model: T! = Mapper<T>().map(JSON: jsonObject) //  TODO: - Mapping failure needs to be evaluated
                success(model!)
            } else if let jsonArray = response as? [Any] {
                let jsonObject = [ResponseKeys.responseContentKey: jsonArray]
                let model: T! = Mapper<T>().map(JSON: jsonObject) //  TODO: - Mapping failure needs to be evaluated
                success(model!)
            } else {
                let nbError = errorModel.convert(message: nil, statusCode: nil, errorModel: nil)
                failure(nbError)
            }
            
        case let .failure(error):
            
            var message: String?
            var codeStatus: Int?
            var mappedError: Mappable?
            
            if !(error is AFError) {
                let nsError: NSError = error as NSError
                message = nsError.localizedDescription
                codeStatus = nsError.code
            } else {
                let afError: AFError = error as! AFError
                codeStatus = afError.responseCode
                message = afError.errorDescription
            }
            
            mappedError = errorModel.convertPayload(withData: data)
            let nbError = errorModel.convert(message: message, statusCode: codeStatus, errorModel: mappedError)
            
            failure(nbError)
        }
    }
}

extension Alamofire.SessionManager {
    
    @discardableResult
    open func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        cachePolicy: URLRequest.CachePolicy)
        -> DataRequest {
            do {
                var urlRequest = try URLRequest(url: url, method: method, headers: headers)
                urlRequest.cachePolicy = cachePolicy
                
                let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
                
                return request(encodedURLRequest)
            } catch {
                return request(URLRequest(url: URL(string: "https://example.com/wrong_request")!))
            }
    }
}

