# Awesome Appliance Repair

1.  Generate a chef-repo using the `chef` command

`chef generate repo chef-repo`

2.  Create a cookbook

* `cd chef-repo/cookbooks`
* `chef generate cookbook aar`

3.  Create and verify a test kitchen for the cookbook

* Update the .kitchen.yml file
* `cd chef-repo/cookbooks/aar`
* Run `kitchen create`, `kitchen converge`, and `kitchen test` to verify everything is working OK.

4.  Switch to ec2 driver to account for the slow network

5.  Write tests for the pre-requisite packages, make tests pass.

* apache
* mysql
* unzip
