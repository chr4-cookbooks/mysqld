require 'serverspec'
require 'pathname'

set :backend, :exec

describe service('mysql') do
  it { should be_enabled }
  it { should be_running }
end

describe port(3306) do
  it { should be_listening }
end

describe command('mysql -uroot -pabcdef01234567890 -N -s -r -e \'select version();\'') do
  its(:stdout) { should match '^10\.2\.' }
  its(:stdout) { should match 'MariaDB' }
end

describe command('mysql -udebian-sys-maint -pabcdef01234567890 -N -s -r -e \'select version();\'') do
  its(:stdout) { should match '^10\.2\.' }
  its(:stdout) { should match 'MariaDB' }
end
