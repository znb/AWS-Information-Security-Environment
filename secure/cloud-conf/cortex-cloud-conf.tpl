#cloud-config
apt_upgrade: true
apt_update: true
locale: en_US.UTF-8
packages:
 - git
 - vim
 - zip
 - unzip
write_files:
  - path: /opt/facter.conf
    content: |
      facts : {
          blocklist : [ "EC2" ],
          ttls : [
            { "timezone" : 30 days },
                ]
              }
  - path: /opt/puppet.conf
    content: |
      [main]
      logdir = /var/log/puppetlabs/puppet
      vardir = /var/lib/puppet
      ssldir = /var/lib/puppet/ssl
      rundir = /run/puppet
      factpath = $vardir/lib/facter

      [master]
      server = pm.example.com
      hiera_config = /etc/puppetlabs/puppet/hiera.yaml

      [agent]
      server = pm.example.com
      report = true
      pluginsync = true
runcmd:
 - sudo echo ${hostname} > /etc/hostname
 - sudo echo ${puppetmaster_private_ip} pm >> /etc/hosts
 - sudo hostnamectl set-hostname ${hostname}
 - sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B
 - sudo mv /opt/puppet.conf /etc/puppetlabs/puppet/
 - sudo mkdir /etc/puppetlabs/facter
 - sudo mv /opt/facter.conf /etc/puppetlabs/facter/
 - sudo -i -u root puppet agent --enable
 - sudo apt-get update
 - sudo apt-get -y update
 - sudo apt-get install -y puppet-agent
 - sudo apt-get install -y python3-pip
 - sudo gem install hiera-eyaml
 - sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
 - sudo echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
 - sudo apt install apt-transport-https
 - sudo apt-get install -yq elasticsearch
 - sudo echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' | sudo tee -a /etc/apt/sources.list.d/java.list
 - sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key EEA14886
 - sudo apt-get install -yq oracle-java8-installer
 - sudo echo 'deb https://dl.bintray.com/thehive-project/debian-stable any main' | sudo tee -a /etc/apt/sources.list.d/thehive-project.list
 - sudo curl https://raw.githubusercontent.com/TheHive-Project/TheHive/master/PGP-PUBLIC-KEY | sudo apt-key add -
 - sudo apt-get update
 - sudo apt-get install cortex
