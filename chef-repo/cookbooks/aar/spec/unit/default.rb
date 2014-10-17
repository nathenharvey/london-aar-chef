require 'chefspec'
require 'chefspec/berkshelf'

describe 'aar::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe)  }

  it "installs the pre-requisite packages" do
    %w{apache2 mysql-server unzip}.each do |p|
      expect(chef_run).to install_package(p)
    end
  end
end
