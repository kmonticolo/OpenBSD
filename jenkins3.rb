# chef-client --local-mode jenkins.rb 

ver="60"
mirror="http://ftp.icm.edu.pl/pub/OpenBSD" # to be override by helper below
#mirror="http://ftp.openbsd.org/pub/OpenBSD" # to be override by helper below


arch=node['kernel']['machine']
unless defined? arch
  puts "verdot not defined"
end

verdot=node['os_version']
unless defined? verdot
  puts "verdot not defined"
end

unless defined? mirror 
  puts "mirror not defined"
end

# zrobic dnsy w resolv.conf bo przy bridgowanym ifie nie dziala net z ustawionym z dhcp
file '/etc/resolv.conf' do
  content 'nameserver 8.8.8.8'
end

file '/etc/hostname.em1' do
  action :delete
end

# download fastest mirror helper
remote_file "/root/testmirrors.sh" do
  source "https://raw.githubusercontent.com/kmonticolo/OpenBSD/master/testmirrors.sh"
  not_if { ::File.exists?("/root/testmirrors.sh") }
end
  
execute 'determine fastest mirror (approx. 4 mins)' do
  user    'root'
  cwd     '/root'
  command 'chmod +x /root/testmirrors.sh'
  command '/bin/sh /root/testmirrors.sh'
  not_if { ::File.exists?("/root/.testmirrors") }
end


if File.exist?('/root/.testmirrors')
  mirror = ::File.read('/root/.testmirrors').chomp
end


# rozpakowac xbase i xfont
remote_file "/tmp/xbase#{ver}.tgz" do
  source "#{mirror}/#{verdot}/#{arch}/xbase#{ver}.tgz"
  #not_if { ::File.exists?("/tmp/xbase#{ver}.tgz") }
  not_if { ::File.exists?("/usr/X11R6/lib/") }
end

bash "unpack xbase from #{mirror}" do
  code <<-EOS
  tar zxpfh /tmp/xbase60.tgz -C /
  ldconfig /usr/X11R6/lib/
  EOS
  not_if { ::File.exists?("/usr/X11R6/lib/") }
end

remote_file "/tmp/xfont#{ver}.tgz" do
  source "#{mirror}/#{verdot}/#{arch}/xfont#{ver}.tgz"
  #not_if { ::File.exists?("/tmp/xfont#{ver}.tgz") }
  not_if { ::File.exists?("/usr/X11R6/lib/X11/fonts/") }
end

bash "unpack xfont" do
  code <<-EOS
  tar zxpfh /tmp/xfont60.tgz -C /
  ldconfig /usr/X11R6/lib/
  EOS
  not_if { ::File.exists?("/usr/X11R6/lib/X11/fonts/") }
end

#package "vim" do
  #version "1.656p0"
#end
package "jenkins" do
  version "1.656p0"
end

service "jenkins" do
  action [:enable, :start]
end

# https://redmine.openinfosecfoundation.org/projects/suricata/wiki/OpenBSD_Installation_from_GIT_with_Chef

# http://ftp.icm.edu.pl/pub/OpenBSD/6.0/sys.tar.gz

remote_file "/tmp/sys.tar.gz" do
  #source "http://ftp.icm.edu.pl/pub/OpenBSD/6.0/sys.tar.gz"
  source "#{mirror}/#{verdot}/sys.tar.gz"
  not_if { ::File.exists?("/usr/src/sys/arch/") }
end

bash "unpack sys.tar.gz" do
  code <<-EOS
  cd /usr/src
  #tar xzf /tmp/src.tar.gz
  tar xzf /tmp/sys.tar.gz
  EOS
  not_if { ::File.exists?("/usr/src/sys/") }
end
 
 # TODO
# sudo access for _jenkins user 
group 'wheel' do
  action :modify
  members '_jenkins'
  append true
end

#joby w jenkins za pomoca dsl

# src
#cd /usr/src
#sudo find . -type l -name obj | sudo xargs rm
#sudo find . -type l -name obj -exec rm {} \;
#cd sys
#sudo make cleandir
#sudo rm -rf /usr/obj/*
#sudo make obj

# kernel
#cd /usr/src/sys/arch/amd64/conf
#sudo config GENERIC
#cd ../compile/GENERIC
#sudo make

