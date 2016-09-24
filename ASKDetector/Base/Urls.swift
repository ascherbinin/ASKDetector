
import UIKit

class Urls
{
    // agregator
    private var accessToken    : String! = ""
    private var baseURL        : String! = ""
    
    init(url: String)
    {
        baseURL        = url
    }
    
    private func addParamToBody(body: String,
        param: String,
        value: String) -> String
    {
        var sign: String = "&"
        if body.isEmpty
        {
            sign = ""
        }
        return body + sign + param + "=" + value
    }
    
    func bodyWithAccessTokenAndOutFormat(body: String, outFormat: String) -> String
    {
        var sign: String = "&"
        if body.isEmpty
        {
            sign = ""
        }
        return body + sign + ACCESS_TOKEN_FIELD + "=" + accessToken + sign + "out=" + outFormat
    }
    
    func setAccessToken(token: String)
    {
        accessToken = token
    }
    
    private func url(partURL: String) -> String
    {
        return baseURL + partURL
    }

    
    // MARK: - URLs
    
    private let currentModule : String! = "/main?"
    
    private var DICTS_FUNC_URL               : String { get { return currentModule + "func=readdicts&" } }
    private var STATE_FUNC_URL               : String { get { return currentModule + "func=state&" } }
  
    // MARK: - Fields
    private let DICTS_FIELD               : String = "dicts"
    private let FUEL_FIELD               : String = "fuel"
    private let OBJECTS_FIELD               : String = "objects"
    private let ACCESS_TOKEN_FIELD        : String = "uid"


    // MARK: - URL functions, agregator
    
    

    func getDictsURL() -> String
    {
        return baseURL + DICTS_FUNC_URL
    }
    
    func getDictsBody(dicts : String) -> String
    {
        var body = ""
        body = addParamToBody(body, param: DICTS_FIELD, value: dicts)
        return bodyWithAccessTokenAndOutFormat(body, outFormat: "json")
    }
    
    func getStateURL() -> String
    {
        return baseURL + STATE_FUNC_URL
    }
    
    func getStateBody(objects : String, fuel: String) -> String
    {
        var body = ""
        body = addParamToBody(body, param: OBJECTS_FIELD, value: objects)
        body = addParamToBody(body, param: FUEL_FIELD, value: fuel)
        return bodyWithAccessTokenAndOutFormat(body, outFormat: "json")
    }
}
