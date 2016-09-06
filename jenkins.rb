#  chef-client --local-mode jenkins.rb 

# zrobic dnsy w resolv.conf

# ustawic pkg_path w /etc/pkg.conf i sprawic, zeby sie sluchal

# rozpakowac xbase
remote_file "/tmp/xbase60.tgz" do
  source "http://ftp.icm.edu.pl/pub/OpenBSD/6.0/amd64/xbase60.tgz"
  not_if { ::File.exists?("/usr/X11R6/lib/") }
end
bash "unpack xbase" do
  code <<-EOS
  tar zxpfh /tmp/xbase60.tgz -C /
  EOS
  not_if { ::File.exists?("/usr/X11R6/lib/") }
end
package "jenkins" do
  version "1.656p0"
end

 #zmienic linijke
#bash-4.3# grep jenkins /etc/rc.conf 
#pkg_scripts=jenkins

# https://redmine.openinfosecfoundation.org/projects/suricata/wiki/OpenBSD_Installation_from_GIT_with_Chef
