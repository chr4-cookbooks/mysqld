#
# Cookbook Name:: mysqld
# Recipe:: mariadb_repository
#
# Copyright 2014, Chris Aumann
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

require 'uri'

apt_repository 'mariadb' do
  uri "#{node['mysqld']['repository']['mirror']}/#{node['mysqld']['repository']['version']}/#{node['platform']}"
  distribution node['lsb']['codename']
  components %w(main)
  keyserver 'keyserver.ubuntu.com'

  # Since Ubuntu xenial, the repository uses a new key
  if node['platform_version'].to_f < 16.04
    key '0xcbcb082a1bb943db'
  else
    key '0xf1656f24c74cd1d8'
  end
end

# Prioritize MariaDB repository over system packages
file '/etc/apt/preferences.d/mariadb.pref' do
  mode 0o644
  content <<-EOS
    Package: *
    Pin: origin #{URI.parse(node['mysqld']['repository']['mirror']).host}
    Pin-Priority: 1000
  EOS
end
