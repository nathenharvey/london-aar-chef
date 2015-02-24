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

service "apache2" do
  action [:start, :enable]
end

## # pip install flask
##     Popen(['pip', 'install', 'flask'], shell=False).wait()
##
python_pip "Flask"

## # Generate the apache config file in sites-enabled
##     Popen(['apachectl', 'stop'], shell=False).wait()
##
##     pth = '/etc/apache2/sites-enabled/'
##     for f in os.listdir(pth):
##         os.remove(pth + f)
##
##     f = open('/etc/apache2/sites-enabled/AAR-apache.conf', 'w')
##     f.write("""
##     <VirtualHost *:80>
##       ServerName /
##       WSGIDaemonProcess /AAR user=www-data group=www-data threads=5
##       WSGIProcessGroup /AAR
##       WSGIScriptAlias / /var/www/AAR/awesomeapp.wsgi
##
##       <Directory /var/www/AAR>
##         WSGIApplicationGroup %{GLOBAL}
##         WSGIScriptReloading On
##         Order deny,allow
##         Allow from all
##       </Directory>
##
##       CustomLog ${APACHE_LOG_DIR}/access.log combined
##       ServerAdmin ops@example.com
##     </VirtualHost>
##     """)
##     f.close()

template "/etc/apache2/sites-available/aar.conf" do
  source "aar.conf.erb"
end

link "/etc/apache2/sites-enabled/aar.conf" do
  to "/etc/apache2/sites-available/aar.conf"
  notifies :restart, "service[apache2]"
end

link "/etc/apache2/sites-enabled/000-default.conf" do
  to "/etc/apache2/sites-available/000-default.conf"
  action :delete
  notifies :restart, "service[apache2]"
end

##
## # Generate AAR_config.py with secrets
##     f = open('/var/www/AAR/AAR_config.py', 'w')
##     appdbpw = binascii.b2a_base64(os.urandom(6)).strip('\n')
##     secretkey = binascii.b2a_base64(os.urandom(12)).strip('\n')

appdbpw = "my_password"
secretkey = "my_secretkey"

##
##     conn_args_string = """CONNECTION_ARGS = {"host":"localhost", "user":"aarapp", "passwd":"%s", "db":"AARdb"}\n\n""" % appdbpw
##
##     secret_key_string = """SECRET_KEY = "%s"\n\n""" % secretkey
##
##     database_values_string = """DB_VALUES = [(3,'Maytag','Washer', None, 'pending', "outflow hoses leak"),(4,'GE','Refrigerator', '2013-11-01', 'completed', "Ices up; won't defrost"), (5,'Alessi','Teapot', None, 'pending', "explodes"), (6,'Amana','Range', '2013-11-02', 'completed', "oven heats unevenly"), (7,'Whirlpool','Refrigerator', '2013-11-03', 'pending', "Makes a rattling noise"), (8,'GE','Microwave', '2013-11-04', 'pending', "Sparks and smokes when I put forks in it"), (9,'Maytag','Drier', None, 'pending', "Never heats up"), (10,'Amana','Refrigerator', '2013-11-05', 'pending', "Temperature too low, can't adjust."), (11,'Samsung','Washer', None, 'pending', "Doesn't get my bear suit white"), (12,'Frigidaire','Refrigerator', '2013-11-06', 'completed', "Has a bad smell I can't get rid of."), (13,'In-Sink-Erator','Dispose-all', None, 'pending', "blades broken"), (14,'KitchenAid','Mixer', '2013-11-07', 'completed', "Blows my fuses"), (15,'Moulinex','Juicer', None, 'pending', "Won't start"), (16,'Viking','Range', '2013-11-08', 'completed', "Gas leak"), (17,'Aga','Range', None, 'pending', "burner cover is cracked"), (18,'Jennaire','Cooktop', '2013-11-09', 'completed', "Glass cracked"), (19,'Wolfe','Stove', None, 'pending', "Burners are uneven"), (20,'LG','Dehumidifier', '2013-11-10', 'pending', "Ices up when external temp is around freezing"), (21,'DeLonghi','Oil Space Heater', None, 'pending', "Smells bad"), (22,'Kenmore','Refrigerator', '2013-11-11', 'pending', "excessive vibration"), (23,'Maytag','Washer/Drier', None, 'pending', "outflow hoses leak"), (24,'GE','Refrigerator', '2013-11-12', 'pending', "Refrigerator light is defective"), (25,'Kenmore','Washer', None, 'pending', "Unbalanced spin cycle"), (26,'Cookmore','Outdoor Grill', '2013-11-13', 'pending', "Smoker box is stuck"), (27,'Kenmore','Water heater', None, 'pending', "Can't adjust temperature"), (28,'Sanyo','Minifridge', '2013-11-14', 'pending', "Makes a lot of noise"), (29,'Bosch','Dishwasher', None, 'pending', "leaves spots on my glasses"), (30,'Whirlpool','Trash Compactor', '2013-11-15', 'pending', "leaking hydraulic fluid")]
##     """
##
##     f.write(conn_args_string + secret_key_string + database_values_string)
##     f.close()

template "/var/www/AAR/AAR_config.py" do
  source "AAR_config.py.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :appdbpw => appdbpw,
    :secretkey => secretkey
  )
end

service "mysql" do
  action [:start, :enable]
end

mysql2_chef_gem 'default'

mysql_connection_info = {
  :host => "localhost",
  :username => "root",
  :password => ""
}
mysql_database "AARdb" do
  connection mysql_connection_info
  action :create
end

##
## # Create DB, user, and permissions
##     import MySQLdb
##     db = MySQLdb.connect(host='localhost', user='root', passwd=root_dbpswd)
##     sql_script = open('make_AARdb.sql', 'r').read()
##
template "#{Chef::Config[:file_cache_path]}/make_AARdb.sql" do
  source "make_AARdb.sql.erb"
end

execute "seed the database" do
  cwd Chef::Config[:file_cache_path]
  command "mysql -u root < make_AARdb.sql"
  not_if "mysql -u root -e \"select table_name from information_schema.tables where table_schema = 'AARdb'\" | grep customer"
end
##     cur = db.cursor()
##     cur.execute(sql_script)
##     cur.close()
##
##     cur = db.cursor()
##     cur.execute('use AARdb')
##     cur.execute("CREATE USER 'aarapp'@'localhost' IDENTIFIED BY %s", (appdbpw,))
##     cur.execute("GRANT CREATE,INSERT,DELETE,UPDATE,SELECT on AARdb.* to aarapp@localhost")
##     cur.close()
##     db.close()

mysql_database_user "aarapp" do
  connection mysql_connection_info
  password appdbpw
  database_name "AARdb"
  privileges [:create, :insert, :delete, :update, :select]
  action [:create, :grant]
end


# Deploy HTML files
%W{
  login.html
  repairRequest.html
}.each do |html_file|
  template "/var/www/AAR/templates/#{html_file}" do
    owner "www-data"
    group "www-data"
    mode "0644"
  end
end
