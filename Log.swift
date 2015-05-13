struct Log {
    enum Level : Int {
        case Trace, Debug, Info, Warning, Error, None
    }
    
    private static let ESCAPE = "\u{001b}["
    
    private static let RESET_FG = ESCAPE + "fg;" // Clear any foreground color
    private static let RESET_BG = ESCAPE + "bg;" // Clear any background color
    private static let RESET = ESCAPE + ";"   // Clear any foreground or background color
    
    private static var colorsEnabled: Bool = {
        let xcodeColors = getenv("XcodeColors")
        let xcodeColorsAvailable = xcodeColors != nil && strcmp(xcodeColors, "YES") == 0
        return xcodeColorsAvailable
    }()
    
    static func error<T>(object:T, file: String = __FILE__, line: Int = __LINE__, function: String = __FUNCTION__) {
        let color = "fg255,0,0;";
        print(object, level: .Error, colorString: color, file: file, line: line, function: function)
    }

    static func warning<T>(object:T, file: String = __FILE__, line: Int = __LINE__, function: String = __FUNCTION__) {
        let color = "fg255,127,0;";
        print(object, level: .Warning, colorString: color, file: file, line: line, function: function)
    }
    
    static func info<T>(object:T, file: String = __FILE__, line: Int = __LINE__, function: String = __FUNCTION__) {
        let color = "fg255,255,0;";
        print(object, level: .Info, colorString: color, file: file, line: line, function: function)
    }

    static func debug<T>(object:T, file: String = __FILE__, line: Int = __LINE__, function: String = __FUNCTION__) {
        let color = "fg70,70,70;";
        print(object, level: .Debug, colorString: color, file: file, line: line, function: function)
    }

    static func trace<T>(object:T, file: String = __FILE__, line: Int = __LINE__, function: String = __FUNCTION__) {

        let color = "fg255,255,255;";
        print(object, level: .Trace, colorString: color, file: file, line: line, function: function)
    }

    private static func print<T>(object:T, level: Log.Level, colorString: String = "", file: String, line: Int, function: String) {
        
        if LogLevel.rawValue > level.rawValue { return }
        
        let file = file.lastPathComponent
        var logString = "[\(file):\(line)] \(function) | \n"
        logString += "\(object)"
        logString += "\n\n"
        
        if self.colorsEnabled {
            println("\(ESCAPE)\(colorString)\(logString)\(RESET)")
        } else {
            println("\(logString)")
        }
    }
}
