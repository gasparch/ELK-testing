
Requested environment
=====================

You will need Vagrant 1.8 and VirtualBox 5.x to run this example.

Get them from 
  https://www.vagrantup.com/downloads.html and
  https://www.virtualbox.org/wiki/Downloads.

It's recommneded to get 'Oracle VM VirtualBox Extension Pack' as well.

Configuration
=============

Before starting vagrant vm provisioning check common.inc.sh file and change
settings for wallabag admin user/password.



Starting machines
=================
Change to top level directory of the project and run `vagrant up`.

You will needd around 15Gb of space for VM images, at least 6Gb RAM.
It will download around 2Gb data to install all packages.


Exposed services
================

You can connect to WallaBag installation using `http://localhost:8000`.

Kibana dashboard is available from `http://localhost:8001`.



Monitoring status of elasticsearch
==================================

To check that elasticsearch started receiving data use
~~~~
watch "curl  'localhost:9200/_cat/indices?v' 2>/dev/null"
~~~~

