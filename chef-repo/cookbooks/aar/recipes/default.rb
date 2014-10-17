#
# Cookbook Name:: aar
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

include_recipe "apt"

package "apache2"

package "mysql-server"
