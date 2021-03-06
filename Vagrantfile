# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Would be great if there was an official box with both
  # VMWare Fusion and VirtualBox support
  config.vm.box = 'petejkim/trusty64'
  config.omnibus.chef_version = :latest
  config.cache.scope = :box if Vagrant.has_plugin?('vagrant-cachier')

  config.vm.provision 'chef_solo' do |chef|
    chef.add_recipe 'zookeeper'
    chef.add_recipe 'zookeeper::discovery'
  end

  config.vm.provision 'shell', inline: <<-EOF.gsub(/^\s*/, '')
    mkdir -p /var/lib/exhibitor
    cat << EOH > /etc/env_vars
    PORT=8181
    CONFIG_TYPE=file
    FS_CONFIG_DIR=/var/lib/exhibitor
    HOSTNAME=`ifconfig eth0 | awk 'sub(/inet addr:/,""){print $1}'`
    EXHIBITOR_HOST=`ifconfig eth0 | awk 'sub(/inet addr:/,""){print $1}'`
    EXHIBITOR_PORT=8181
    EXHIBITOR_AUTH="basic"
    EXHIBITOR_PASS="exhibitor-password"
    EOH
    . /etc/env_vars
    cat << EOH > /etc/exhibitor/realm
    exhibitor: $EXHIBITOR_PASS,exhibitor
    EOH
    rm -f /etc/init/exhibitor-discovery.override
    start exhibitor || true
    start exhibitor-discovery || true
  EOF
end
