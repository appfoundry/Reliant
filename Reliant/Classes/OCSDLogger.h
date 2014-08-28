//
//  OCSDLogger.h
//  Reliant
//
//  Created by Michael Seghers on 1/11/13.
//
//

#ifdef LOG_RELIANT
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif
