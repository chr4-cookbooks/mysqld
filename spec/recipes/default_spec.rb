require_relative '../spec_helper'

require 'chefspec/berkshelf'

describe 'mysqld::default' do
  let(:debian) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04').converge(described_recipe)
  end

  let(:ubuntu_1604) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe)
  end

  it 'should use the correct mysql server package' do
    expect(debian.node['mysqld']['mysql_packages']).to eq(%w(mysql-server))
    expect(ubuntu_1604.node['mysqld']['mysql_packages']).to eq(%w(mysql-server))
  end

  it 'should use distribution specific my.cnf path' do
    expect(debian.node['mysqld']['my.cnf_path']).to eq('/etc/mysql/my.cnf')
    expect(ubuntu_1604.node['mysqld']['my.cnf_path']).to eq('/etc/mysql/my.cnf')
  end

  it 'should use distribution specific service name' do
    expect(debian.node['mysqld']['service_name']).to eq('mysql')
    expect(ubuntu_1604.node['mysqld']['service_name']).to eq('mysql')
  end

  it 'should run mysqld_default provider' do
    expect(debian).to create_mysqld
    expect(ubuntu_1604).to create_mysqld
  end

  it 'should use distribution and version specific attributes' do
    expect(ubuntu_1604.node['mysqld']['my.cnf']['mysqld']['key_buffer_size']).to eq('16M')
    expect(debian.node['mysqld']['my.cnf']['mysqld']['key_buffer_size']).to eq('16M')

    expect(ubuntu_1604.node['mysqld']['my.cnf']['mysqld']['myisam-recover-options']).to eq('BACKUP')
    expect(debian.node['mysqld']['my.cnf']['mysqld']['myisam-recover-options']).to eq('BACKUP')
  end
end
