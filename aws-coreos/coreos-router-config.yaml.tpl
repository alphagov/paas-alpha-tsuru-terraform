#cloud-config

coreos:
  fleet:
    etcd_servers: ${etcd_servers}
    metadata: "role=router,provider=aws"
  units:
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

