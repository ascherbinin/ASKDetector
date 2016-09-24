

import UIKit

typealias successAction = (NSDictionary) -> Void
typealias errorAction = (NSError) -> Void

protocol ServerDelegate
{
    
    func onRefreshAccessToken()
    func onRefreshTokenInvalid()
    func onTimeoutError()
    
    func onShowError(err: String)
    
}
     
enum Priority: Int
{
case Low = 0
case Medium
case High
}

class Server
{
    
    var isProcessing : Bool! = false
    var delegate     : ServerDelegate!
    var requests     : NSMutableArray!
    var timer        : NSTimer!
    var timeout      : NSTimeInterval!
    var urls         : Urls!
    var curRequest   : Request!
    var `repeat`     : Request?
    var accessToken  : String! = ""
    
    var mainSession: NSURLSession!
    
    // MARK: - init
    
    convenience init(urls_: Urls,
        requestTimeout: NSTimeInterval)
    {
        self.init()
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        // makes it work like a queue
        config.HTTPMaximumConnectionsPerHost = 1
        // dont understand the difference of parameters below
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 10
        
        //cahce policy
        config.requestCachePolicy = .ReloadIgnoringLocalAndRemoteCacheData
        //config.requestCachePolicy = .ReturnCacheDataElseLoad
        mainSession = NSURLSession(configuration: config)
        
        isProcessing = false
        requests     = NSMutableArray()
        timeout      = requestTimeout
        urls         = urls_
        timer        = NSTimer()
    }
    
    func repeatLastRequest()
    {
        if (`repeat` != nil)
        {
            requests.addObject(`repeat`!)
        }
    }
    
    func setAToken(atoken: String)
    {
        self.accessToken = atoken
        self.urls.setAccessToken(atoken)
    }
    
    func reset()
    {
        let n = requests.count
        if (n > 1)
        {
            requests.removeObjectsInRange(NSMakeRange(1, n - 1));
        }
    }
    
    // MARK: - Requests
    
    func requestDict(dict: String,
                     action: successAction,
                     error: errorAction)
    {
        request(urls.getDictsURL(),
                action: action,
                error: error,
                post: false,
                body: urls.getDictsBody(dict))
    }
    
    func requestState(objects: String,
                      fuel: String,
                     action: successAction,
                     error: errorAction)
    {
        request(urls.getStateURL(),
                action: action,
                error: error,
                post: false,
                body: urls.getStateBody(objects, fuel: fuel) )
    }

    // MARK: - Queue requests
    
    private func request(url: String,
        action: successAction,
        error: errorAction,
        post: Bool,
        body: String)
    {
        let request = Request(url: url,
            action: action,
            error: error,
            post: post,
            body: body,
            data: nil)
        process(request)
    }
    
    private func request(url: String,
        action: successAction,
        error: errorAction,
        post: Bool,
        body: String,
        priority: Priority)
    {
        let request = Request(url: url,
            action: action,
            error: error,
            post: post,
            body: body,
            priority:priority,
            data: nil)
        process(request)
    }

    // MARK: - Server queue
    
    private func markCurrentRequestAsProcessedAndProceed()
    {
        isProcessing = false
        if requests.count > 0
        {
            requests.removeObject(curRequest)
        }
        processQueue()
    }
    
    
    private func priorityRequest() -> Request
    {
        var retRequest = requests[0] as! Request
        for request in requests
        {
            if (retRequest.priority.rawValue < (request as! Request).priority.rawValue)
            {
                retRequest = request as! Request
            }
        }
        return retRequest
    }
    
    private func process(request: Request)
    {
        requests.addObject(request)
        processQueue()
    }

    
    private func processErrorCode(code: Int,
        response: String)
    {
        var error = ""
        switch (code)
        {
        case 401:
            error = loc("AUTH_ERROR")
        case 404:
            error = loc("FUNC_NOT_FOUND_ERROR")
        case 500:
            error = loc("INTERNAL_ERROR")
        case 1000:
            error = loc("REQUEST_EXCEPTION")
        default:
            error = ""
        }
        if !error.isEmpty
        {
            delegate.onShowError(error)
        }
   /*     else
        {
            delegate.onShowError(NSLocalizedString("UNKNOWN_ERROR", comment: ""))
        }*/
    }
//    func sendSynchronousRequest(dict: String)
//    {
//        // Send a synchronous request
//        let urlRequest = NSURLRequest(NSURL(string: "")
//            [
//            NSURLRequest requestWithURL:[NSURL URLWithString:@"enter your url here"]];
//        NSURLResponse * response = nil;
//        NSError * error = nil;
//        NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
//        returningResponse:&response
//        error:&error];
//    
//        if (error == nil)
//        {
//        // Parse data here
//        }
//    }
    
    private func processImplWithRequest(r: Request)
    {
        let request = NSMutableURLRequest(URL: NSURL(string: r.url + r.body)!,
            cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy,
            timeoutInterval: timeout)
//        if r.post == true
//        {
//            request.HTTPMethod = "POST"
//        }
//        if !r.body.isEmpty
//        {
//            request.HTTPBody = r.body.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
//        }
        showNetworkActivityIfSlow(true)
        
        NSURLConnection.sendAsynchronousRequest(request,
            queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
                self.showNetworkActivityIfSlow(false)
                var err : NSError? = nil
                if data != nil
                {
                    do {
                        let d: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                        if let dict = d as? NSDictionary
                        {
                            if ((dict["success"]?.boolValue == true || dict["success"] == nil) && dict["error"] == nil)
                            {
                                r.action(dict)
                            }
                            else
                            {
                                var codeError = 0
                                if let code = dict["code"] as? NSNumber
                                {
                                    codeError = code.integerValue ?? 0
                                    if let response = dict["response"] as? String
                                    {
                                        self.processErrorCode(code.integerValue,
                                            response: response)
                                    }
                                    else
                                    {
                                        self.processErrorCode(code.integerValue,
                                            response: "")
                                    }
                                }
                                else if let code = dict["error"]?["code"] as? NSNumber
                                {
                                    codeError = code.integerValue ?? 0
                                    self.processErrorCode(code.integerValue,
                                        response: "")
                                }
                                r.error(NSError(domain: "Server", code: 100, userInfo: nil))
                            }
                        }
                    } catch let error1 as NSError {
                        err = error1
                        r.error(err!)
                    } catch {
                        fatalError()
                    }
                }
                else
                {
                    r.error(NSError(domain: "Server", code: 101, userInfo: nil))
                }
                if error != nil
                {
                    self.processErrorCode(error!.code,
                        response: "")
                    r.error(error!)
                }
                self.markCurrentRequestAsProcessedAndProceed();
        }
    }
    
    func generateBoundaryString() -> String {
        return "\(NSUUID().UUIDString)"
    }
    
    private func processQueue()
    {
        if isProcessing == true || requests.count == 0
        {
            return;
        }
        isProcessing = true
        curRequest = priorityRequest()
        processImplWithRequest(curRequest)
    }
    
    private func processServerError(code: String)
    {

    }
    
    private func showNetworkActivityIfSlow(state: Bool)
    {
        #if !TODAY_EXTENSION
            UIApplication.sharedApplication().networkActivityIndicatorVisible = state
        #endif
        
        if state == true
        {
            // Stop the old timer before starting a new one.
            timer = NSTimer(timeInterval: 1,
                target: self,
                selector: Selector("onShowNetworkActivity"),
                userInfo: nil,
                repeats: false)
            showNetworkActivityIfSlow(false)
        }
        else if timer.valid == true
        {
            timer.invalidate()
        }
    }
}
