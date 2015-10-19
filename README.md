# The damn simple Swift Logger
Lightweight Swift logger with color support.


## Install
Drop `Log.swift` in your project and configure your desired log level like this:

```
#if DEBUG
Log.Level = .Trace
#else
Log.Level = .Error
#endif
```

## Usage
The available levels are `Trace`, `Debug`, `Info`, `Warning`, `Error`. There is also a `None` level that can be used to disable logging.

You can log using two different fashions:

1. **Simple**, without annotations about file, line and function name.
2. **Extended**, with annotations about file, line and function name.

### Simple logging
You can log using either the `=>` operator or the `print` function (passing `false` to the `extended` parameter)

Example:

```
"Fatal error!" => Log.Error
// or
Log.Error.print("Fatal error!", extended: false)

// will both print 
3:12:14 PM: Fatal error!
```





### Extended logging
If you need more details, you can use the `print` function, without passing any parameter.

Example:

```
Log.Error.print("Fatal error!")

// Will print:
[AppDelegate.swift:28] application(_:didFinishLaunchingWithOptions:) | 
3:23:26 PM: Fatal error!
```



## Colors support

Just install [XcodeColors](https://github.com/robbiehanson/XcodeColors), and it will just work!



## Customization

### Print format
You can format both the simple and the extended log as you want, by replacing the default `Log.simpleFormatter` and `Log.extendedFormatter` functions.

Example:

```
Log.simpleFormatter = { object in
	return "Object: \(object)"
}
```

### Print function
By default, Log will print using the standard `Swift.print` function. If you prefer to print using your custom implementation (i.e. if you want to log to a file), just hook a function to `Log.printFunction` conforming to this signature `(items: Any..., separator: String, terminator: String) -> Void`.


### Colors
You can define your own colors providing a new function to the `colorForLevel` property, with signature `(level: Log) -> UIColor`. 


### Date formatter
You can define your own date formatter replacing the default `Log.dateFormatter`.


## Known issues and limitations

There are both **simple** and **extended** logging due to an operator limit: to add the file, line and function information I need to pass them as default parameters of a function, but this isn't possible on operator functions.

To better explain, the `print` function is defined like this:

`public func print(object:Any, extended: Bool = true, file: String = __FILE__, line: Int = __LINE__, function: String = __FUNCTION__)`
 
Unfortunately, I can't do a similar thing with the operator function:

`public func =>(lhs: Any, rhs: Log, file: String = __FILE__, line: Int = __LINE__, function: String = __FUNCTION__)`

Will fail with:
> Operators must have one or two arguments

So I can't find a way to log the extended info while using the `=>` operator.

If you find a way to solve it, please open a new issue or a pull request.


## Contributing

Feel free to fork the project and extend the behavior. Pull requests are welcome.
