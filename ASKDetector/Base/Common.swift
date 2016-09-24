
import UIKit
import AVFoundation

// global const

let APP_VERSION = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
let BUILD_VERSION = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String
let UUID = UIDevice.currentDevice().identifierForVendor!.UUIDString
let PLATFORM_VERSION = UIDevice.currentDevice().systemVersion
let UID = ""; // Need paste your uid in this place

// size from design
let HEADER_HEIGHT = 60 as CGFloat


// functions

// short version of NSLocalizedString
func loc(key: String) -> String
{
    return NSLocalizedString(key, comment: "")
}

func loc(key: String, parameters: CVarArgType ...) -> String
{
    return String(format: NSLocalizedString(key, comment: ""), arguments: parameters)
}

// return 1x1 image with rgb color
func imageWithColor(color: UIColor) -> UIImage
{
    let rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    // button image from RGB color
    UIGraphicsBeginImageContext(rect.size);
    let context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    let img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

// configure navigation bar color
func setNavigationBarColor(color: UIColor,
    bar: UINavigationBar)
{
    let titleDict: NSDictionary = [NSForegroundColorAttributeName: color]
    bar.titleTextAttributes = titleDict as? [String: AnyObject]
}

func appendingString(inout mainString: String, newString: String?)
{
    if mainString.isEmpty
    {
        mainString += newString!
    }
    else
    {
        mainString += ", \(newString!)"
    }
}

