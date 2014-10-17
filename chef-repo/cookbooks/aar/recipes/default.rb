#
# Cookbook Name:: aar
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

include_recipe "apt"

# The following script assumes that apache2, mysql, and unzip have been installed.
# # apt-get the stuff we need
#     proc = Popen([
#         'apt-get', 'install', '-y',
#         'libapache2-mod-wsgi',
#         'python-pip',
#         'python-mysqldb'], shell=False)
#     proc.wait()
%w{apache2 mysql-server unzip libapache2-mod-wsgi python-pip python-mysqldb }.each do |p|
  package p
end

# 1. wget https://github.com/colincam/Awesome-Appliance-Repair/archive/master.zip
# 2. unzip master.zip
# 3. cd into Awesome-Appliance-Repair
# 4. sudo mv AAR to /var/www/

directory "/var/www/" do
  recursive true
end

ark 'Awesome-Appliance-Repair' do
  url 'https://github.com/colincam/Awesome-Appliance-Repair/archive/master.zip'
  path "/var/tmp"
  owner "www-data"
  group "www-data"
  action :put
end

execute "move AAR into place" do
  command "mv /var/tmp/Awesome-Appliance-Repair/AAR /var/www"
  only_if { File.directory?("/var/tmp/Awesome-Appliance-Repair/AAR") }
end
