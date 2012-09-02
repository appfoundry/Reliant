//
//  Setup.m
//  Devoxx Scheduler
//
//  Created by Michael Seghers on 9/08/12.
//  Copyright (c) 2012 iDA MediaFoundry. All rights reserved.
//
#include <stdio.h>
#import "Setup.h"

@implementation Setup

@end


// Prototype declarations
FILE *fopen$UNIX2003( const char *filename, const char *mode );
size_t fwrite$UNIX2003( const void *a, size_t b, size_t c, FILE *d );

FILE *fopen$UNIX2003( const char *filename, const char *mode ) {
    return fopen(filename, mode);
}
size_t fwrite$UNIX2003( const void *a, size_t b, size_t c, FILE *d ) {
    return fwrite(a, b, c, d);
}