#!/usr/bin/env python

import sys
import os
import sys

from optparse import OptionParser

def RunCmd(s):
    print "Running:%s" % s
    os.system(s)

def main():
    '''
    This is just the main routine
    '''
    
    usage = "usage: %prog -p projname -d dirname (in svn)"
    parser = OptionParser(usage)
    parser.add_option("-p", "--proj", dest="proj",
                      action="store",
                      type="string",
                      help="Project name to add.")
    parser.add_option("-d", "--dir", dest="dir",
                      action="store",
                      type="string",
                      help="Directory under svn to store it.")
    parser.add_option("-u", "--url", dest="url",
                      action="store",
                      type="string",
                      default="https://deepbondi.devguard.com/svn/bondiproj/Rails",
                      help="the main part of the URL.")
    
    (options, args) = parser.parse_args()
    
    '''
    Can check any options. If an option does not have a default,
    then it will be "None", which is false in an if statement
    '''
    
    url = options.url
    
    if not options.proj:
        parser.error("You must specify a project to use this script.")
        
    if not options.dir:
        parser.error("You must specify a directory also.. this is the sourc dir.")
        

    '''
    Make sure the directory exists first.
    IF it does, then build a project dir with trunk, tags, brances
    then, import the dir into trunk.
    '''
   
    if os.path.isdir(options.dir):
        cmd = "svn mkdir %s/%s -m \"Adding new project dir\"" % (url,options.proj)
        RunCmd(cmd)
        for projdir in ['trunk','branches','tags']:
            cmd = "svn mkdir %s/%s/%s -m \"Adding new dir\"" % (url,options.proj,projdir)
            RunCmd(cmd)

        cmd = 'svn import %s %s/%s/trunk -m \"Importing %s\"' % (options.dir,url,options.proj,options.proj)
        RunCmd(cmd)

'''
This is just how Python scripts start nothing special..
It is possible to just put everything "at the top level" and hove none
of this, but it's a standard technique to put everything in the 'main'
routine
'''
if __name__ == '__main__':
    main()

