
import UIKit

class Request
{
    var url      : String!
    var action   : successAction!
    var error    : errorAction!
    var post     : Bool!
    var body     : String!
    var priority : Priority
    var data     : NSData?
    
    init(url    : String,
        action  : successAction,
        error   : errorAction,
        post    : Bool,
        body    : String,
        data    : NSData?)
    {
        self.url      = url
        self.action   = action
        self.error    = error
        self.post     = post
        self.body     = body
        self.priority = Priority.Low
        self.data     = data
    }
    
    init(url    : String,
        action  : successAction,
        error   : errorAction,
        post    : Bool,
        body    : String,
        priority: Priority,
        data    : NSData?)
    {
        self.url      = url
        self.action   = action
        self.error    = error
        self.post     = post
        self.body     = body
        self.priority = priority
        self.data     = data
    }
}
