//
//  main.m
//  APEYE
//
//  Created by Brady Love on 9/13/12.
//  Copyright (c) 2012 Brady Love. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
    return macruby_main("rb_main.rb", argc, argv);
}
