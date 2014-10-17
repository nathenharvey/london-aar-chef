#
# Cookbook Name:: aar
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

include_recipe "apt"

# The following script assumes that apache2, mysql, and unzip have been installed.
%w{apache2 mysql-server unzip}.each do |p|
  package p
end

# 1. wget https://github.com/colincam/Awesome-Appliance-Repair/archive/master.zip
# 2. unzip master.zip
# 3. cd into Awesome-Appliance-Repair
# 4. sudo mv AAR to /var/www/

