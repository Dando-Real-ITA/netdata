[netdata-edge]
name=Netdata Edge
baseurl=https://packagecloud.io/netdata/netdata-edge/ol/$releasever/$basearch
repo_gpgcheck=1
gpgcheck=0
gpgkey=https://packagecloud.io/netdata/netdata-edge/gpgkey
enabled=1
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt

[netdata-repoconfig]
name=Netdata Repository Config
baseurl=https://packagecloud.io/netdata/netdata-repoconfig/ol/$releasever/$basearch
repo_gpgcheck=1
gpgcheck=0
gpgkey=https://packagecloud.io/netdata/netdata-repoconfig/gpgkey
enabled=1
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
