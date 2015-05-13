# SimpleSwiftLogger
Simple Swift logger with colors support.
It started as a simple single-project only file, but I would like to extend it.

## Install
Drop in your project and configure your desired log level like this:

```
#if DEBUG
let LogLevel : Log.Level = .Trace
#else
let LogLevel : Log.Level = .Error
#endif
```

## Usage
Call the method referring to the desided log level:

`Log.error("Fatal error!")`

At the moment the available levels are `error`, `warning`, `info`, `debug`, `trace`.

## Customization
There is no direct way to customize it at the moment, except editing the main file. The core function is the `print` method that formats the log. Colors are defined inside the level methods.

## Colors support

Just install [XcodeColors](https://github.com/robbiehanson/XcodeColors), and it will just work!

## Contributing

Feel free to fork the project and extend the behavior. Pull requests are welcome.
