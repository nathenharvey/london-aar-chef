require 'spec_helper'

describe 'aar::default' do
  before do
    stub_command("mysql -u root -e \"select table_name from information_schema.tables where table_schema = 'AARdb'\" | grep customer").and_return(true)
  end
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe)  }

  it "installs the pre-requisite packages" do
    %w{apache2 mysql-server unzip libapache2-mod-wsgi python-pip python-mysqldb }.each do |p|
      expect(chef_run).to install_package(p)
    end
  end

  it "installs Flask" do
    expect(chef_run).to install_python_pip("Flask")
  end

  it "creates a virtual host file" do
    expect(chef_run).to render_file("/etc/apache2/sites-available/aar.conf").with_content("VirtualHost")
  end

  it "creates a configuration file for the application" do
    expect(chef_run).to render_file("/var/www/AAR/AAR_config.py").with_content("CONNECTION_ARGS")
    expect(chef_run).to render_file("/var/www/AAR/AAR_config.py").with_content("SECRET_KEY")
    expect(chef_run).to render_file("/var/www/AAR/AAR_config.py").with_content("DB_VALUES")
  end

  it "runs the mysql service" do
    expect(chef_run).to start_service('mysql')
  end

  it "enables the mysql service" do
    expect(chef_run).to enable_service('mysql')
  end

  it "creates the AARdb database" do
    expect(chef_run).to create_mysql_database("AARdb")
  end

  it "starts apahce" do
    expect(chef_run).to start_service("apache2")
  end

  it "enables apahce" do
    expect(chef_run).to enable_service("apache2")
  end

  it "deploy login.html page with right version" do
    expect(chef_run).to render_file("/var/www/AAR/templates/login.html").with_content("v.0.1.0")
  end

  it "deploy repairRequest.html without a Promotion" do
    expect(chef_run).to render_file("/var/www/AAR/templates/repairRequest.html")
    expect(chef_run).to render_file("/var/www/AAR/templates/repairRequest.html").with_content("Request for Repair")
    expect(chef_run).to_not render_file("/var/www/AAR/templates/repairRequest.html").with_content("Promotion of the day")
  end
end
