#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Mimics GeoServer admin UI updating its config dir (also known as "the datadir")
# What this script does:
#  * it creates one new file every PERIOD seconds (defaults to 10)
#  * it modifies the updateSequence value in the global.xml file at the same time

import os, sys
import time, datetime
import signal

# see http://stackoverflow.com/questions/18499497/how-to-process-sigterm-signal-gracefully
class GracefulKiller:
  kill_now = False
  def __init__(self):
    signal.signal(signal.SIGINT, self.exit_gracefully)
    signal.signal(signal.SIGTERM, self.exit_gracefully)

  def exit_gracefully(self, signum, frame):
    self.kill_now = True


path = os.getenv('DATADIR_PATH', '/tmp')
period = os.getenv('PERIOD', 10)

def main():
    killer = GracefulKiller()
    global_filename = path + '/global.xml'
    while True:
        now = str(datetime.datetime.now())
        sys.stdout.write("Updating datadir at "+now+"\n")
        sys.stdout.flush()
        ts = str(int(time.time()))
        f = open(path + '/' + ts, 'w')
        f.write(now + "\n")
        f.close()
        f = open(global_filename, 'w+')
        f.write("<updateSequence>"+now+"</updateSequence>\n")
        f.close()
        time.sleep(period)
        if killer.kill_now:
          break
    print "Killed. Exiting !"

if __name__ == "__main__":
    main()
