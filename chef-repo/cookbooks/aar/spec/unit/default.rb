require 'chefspec'
require 'chefspec/berkshelf'

describe 'aar::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe)  }

  it "installs the pre-requisite packages" do
    %w{apache2 mysql-server unzip libapache2-mod-wsgi python-pip python-mysqldb }.each do |p|
      expect(chef_run).to install_package(p)
    end
  end

  it "installs Flask" do
    expect(chef_run).to install_python_pip("Flask")
  end

  it "creates a virtual host file" do
    expect(chef_run).to render_file("/etc/apache2/sites-available/aar.conf")
  end
end
