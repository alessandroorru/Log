public enum Log : Int {
    case Trace, Debug, Info, Warning, Error, None

    public typealias PrintFunction = (items: Any..., separator: String, terminator: String) -> Void
    public typealias SimpleFormatter = (object: Any) -> String
    public typealias ExtendedFormatter = (object: Any, file: String, line: Int, function: String) -> String
    public typealias ColorForLevel = (level: Log) -> UIColor
    
    public static var Level : Log = Log.Error
    public static var printFunction : PrintFunction = Swift.print
    public static var simpleFormatter : SimpleFormatter = Log.format
    public static var extendedFormatter : ExtendedFormatter = Log.format
    public static var colorForLevel : ColorForLevel = Log.colorForLevel
    
    public static var dateFormatter : NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .MediumStyle
        dateFormatter.locale = NSLocale.systemLocale()
        return dateFormatter
    }()
    
    public func print(object:Any, extended: Bool = true, file: String = __FILE__, line: Int = __LINE__, function: String = __FUNCTION__) {
        guard rawValue >= Log.Level.rawValue else {
            return
        }
        
        let color = colorString()
        var formattedString : String
        switch extended {
        case false:
            formattedString = Log.simpleFormatter(object: object)
        case true:
            formattedString = Log.extendedFormatter(object: object, file: file, line: line, function: function)
        }
        
        if Log.colorsEnabled {
            formattedString = "\(Log.ESCAPE)\(color)\(formattedString)\(Log.RESET)"
        }
        
        Log.printFunction(items: formattedString, separator: ",", terminator: "\n")
    }
    
    
    // MARK: - Private
    private func colorString() -> String {
        let color = Log.colorForLevel(self)
        
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        var a : CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(format: "fg%.0f,%.0f,%.0f;", arguments: [round(r*255), round(g*255), round(b*255)])
    }
    
    private static func colorForLevel(level: Log) -> UIColor {
        switch level {
        case .Trace:
            return UIColor.whiteColor()
        case .Debug:
            return UIColor.darkGrayColor()
        case .Info:
            return UIColor.yellowColor()
        case .Warning:
            return UIColor.orangeColor()
        case .Error:
            return UIColor.redColor()
        default:
            return UIColor.whiteColor()
        }
    }
    
    private static func format(object: Any) -> String {
        return "\(Log.dateFormatter.stringFromDate(NSDate())): \(object)"
    }

    private static func format(object: Any, file: String, line: Int, function: String) -> String {
        let file = file.componentsSeparatedByString("/").last!
        var logString = "\n\n[\(file):\(line)] \(function) | \n"
        logString += "\(Log.dateFormatter.stringFromDate(NSDate())): \(object)"
        logString += "\n"
        
        return logString
    }
    
    private static var colorsEnabled: Bool = {
        let xcodeColors = NSProcessInfo().environment["XcodeColors"]
        let xcodeColorsAvailable = xcodeColors != nil && xcodeColors == "YES"
        return xcodeColorsAvailable
    }()
    
    private static let ESCAPE = "\u{001b}["
    private static let RESET_FG = "\(ESCAPE) fg;" // Clear any foreground color
    private static let RESET_BG = "\(ESCAPE) bg;" // Clear any background color
    private static let RESET = "\(ESCAPE);"   // Clear any foreground or background color
}


infix operator => {}
public func =>(lhs: Any, rhs: Log) {
    rhs.print(lhs, extended: false)
}