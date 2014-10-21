require 'serverspec'
set :backend, :exec

# set :path, '/sbin:/usr/local/sbin:$PATH'
describe "awesome appliance repair" do

  %w{apache2 mysql-server unzip libapache2-mod-wsgi python-pip python-mysqldb }.each do |p|
    it "has #{p} installed" do
      expect(package(p)).to be_installed
    end
  end

  it "has apache installed" do
    expect(package('apache2')).to be_installed
  end

  it "has mysql-server installed" do
    expect(package('mysql-server')).to be_installed
  end

  it "has unzip installed" do
    expect(package('unzip')).to be_installed
  end

  it "creates /var/www/AAR/awesomeapp.py" do
    expect(file("/var/www/AAR/awesomeapp.py")).to be_a_file
  end

  it "application files are owned by www-data" do
    expect(file("/var/www/AAR/awesomeapp.py")).to be_owned_by "www-data"
    expect(file("/var/www/AAR/awesomeapp.py")).to be_grouped_into "www-data"
  end

  it "has a Flask installed" do
    expect(command("pip freeze | grep Flask").exit_status).to eq 0
  end

  it "has a virtual host configured for the application" do
    expect(file("/etc/apache2/sites-enabled/aar.conf")).to be_file
    expect(file("/etc/apache2/sites-enabled/aar.conf").content).to match /VirtualHost/
  end
end
