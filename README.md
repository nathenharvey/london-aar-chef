# Awesome Appliance Repair

#### Generate a chef-repo using the `chef` command

`chef generate repo chef-repo`

#### Create a cookbook

* `cd chef-repo/cookbooks`
* `chef generate cookbook aar`

#### Create and verify a test kitchen for the cookbook

* Update the .kitchen.yml file
* `cd chef-repo/cookbooks/aar`
* Run `kitchen create`, `kitchen converge`, and `kitchen test` to verify everything is working OK.

#### Switch to ec2 driver to account for the slow network

#### Write tests for the pre-requisite packages, make tests pass.

* apache
* mysql
* unzip

#### Refactor

#### Get the application source from Github

#### Install Flask with pip

#### Manage the virtual host configuration

* `chef generate template cookbooks/aar aar.conf`

#### Create AAR_config.py file

* `chef generate template cookbooks/aar AAR_config.py`

#### Create Database
