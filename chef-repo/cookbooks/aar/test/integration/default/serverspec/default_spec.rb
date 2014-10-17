require 'serverspec'
set :backend, :exec

# set :path, '/sbin:/usr/local/sbin:$PATH'
describe "awesome appliance repair" do
  it "has apache installed" do
    expect(package('apache2')).to be_installed
  end
end
