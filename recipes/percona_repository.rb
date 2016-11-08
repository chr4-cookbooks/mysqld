#
# Cookbook Name:: mysqld
# Recipe:: percona_repository
#
# Copyright 2014, Chris Aumann
# Copyright 2016, Adrian Almenar
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

apt_repository 'percona' do
  uri node['mysqld']['repository']['percona']['mirror']
  distribution node['lsb']['codename']
  components %w(main)
  keyserver 'keyserver.ubuntu.com'
  key '8507EFA5'
end

# Prioritize Percona repository over system packages
file '/etc/apt/preferences.d/percona.pref' do
  mode 0o644
  content <<-EOS
    Package: *
    Pin: release o=Percona Development Team
    Pin-Priority: 1001
  EOS
end
