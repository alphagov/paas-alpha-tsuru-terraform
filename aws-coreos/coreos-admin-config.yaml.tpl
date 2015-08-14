#cloud-config

coreos:
  etcd2:
    discovery: ${etcd_discovery_url}
    advertise-client-urls: http://$private_ipv4:2379
    initial-advertise-peer-urls: http://$private_ipv4:2380
    listen-client-urls: http://0.0.0.0:2379
    listen-peer-urls: http://$private_ipv4:2380
  fleet:
    etcd_servers: http://$private_ipv4:2379
    metadata: "${fleet_metadata}"

  units:
    - name: etcd2.service
      command: start
    - name: fleet-tcp.socket
      command: start
      enable: true
      content: |
        [Unit]
        Description=Fleet Socket for API

        [Socket]
        ListenStream=4002
        Service=fleet.service
        BindIPv6Only=both

        [Install]
        WantedBy=sockets.target
    - name: fleet.service
      command: start
    - name: docker-tcp.socket
      command: start
      enable: true
      content: |
        [Unit]
        Description=Docker Socket for the API

        [Socket]
        ListenStream=4243
        Service=docker.service
        BindIPv6Only=both

        [Install]
        WantedBy=sockets.target
    - name: docker.service
      command: start
