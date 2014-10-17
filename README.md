# Awesome Appliance Repair

1.  Generate a chef-repo using the `chef` command

`chef generate repo chef-repo`

1.  Create a cookbook

* `cd chef-repo/cookbooks`
* `chef generate cookbook aar`

1.  Create and verify a test kitchen for the cookbook

* Update the .kitchen.yml file
* cd chef-repo/cookbooks/aar
* Run `kitchen create`, `kitchen converge`, and `kitchen test` to verify everything is working OK.
