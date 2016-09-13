# Install Chef
touch /root/.gemrc ~/.gemrc
# Uncomment two lines below only in case when you have SSL issues behind a corporate http/s proxy
grep -q  ":ssl_verify_mode: 0" /root/.gemrc || echo ":ssl_verify_mode: 0" >/root/.gemrc
grep -q  ":ssl_verify_mode: 0" ~/.gemrc || echo ":ssl_verify_mode: 0" >~/.gemrc
gem install chef --no-ri --no-rdoc
