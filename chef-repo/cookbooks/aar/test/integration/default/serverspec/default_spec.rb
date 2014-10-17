require 'serverspec'
set :backend, :exec

# set :path, '/sbin:/usr/local/sbin:$PATH'
describe "awesome appliance repair" do
  it "has apache installed" do
    expect(package('apache2')).to be_installed
  end

  it "mysql-server" do
    expect(package('mysql-server')).to be_installed
  end

  it "unzip" do
    expect(package('unzip')).to be_installed
  end
end
