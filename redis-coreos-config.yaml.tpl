#cloud-config

coreos:
  etcd2:
    discovery: ${redis_etcd_discovery_url}
    advertise-client-urls: http://$private_ipv4:2379
    initial-advertise-peer-urls: http://$private_ipv4:2380
    listen-client-urls: http://0.0.0.0:2379
    listen-peer-urls: http://$private_ipv4:2380

  units:
    - name: etcd2.service
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
      drop-ins:
        - name: 50-insecure-registry.conf
          content: |
            [Service]
            Environment=DOCKER_OPTS='--insecure-registry="${docker_registry_host}"'
    - name: telegraf.service
      command: start
      enable: true
      content: |
        [Unit]
        Description=Telegraf container
        Requires=docker.service
        After=docker.service

        [Service]
        Restart=always
        ExecStart=/usr/bin/docker run \
          --name telegraf \
          -v /proc:/host/proc \
          -v /sys:/host/sys \
          -v /dev:/host/dev \
          -e TELEGRAF_INFLUX_DB_URL=http://${influx_db_host}:8086 \
          -e TELEGRAF_INFLUX_DB_NAME=influxdb \
          -e TELEGRAF_INFLUX_DB_USER_NAME=influxdb \
          -e TELEGRAF_INFLUX_DB_PASSWORD=influxdb \
          -e TELEGRAF_INFLUX_TAGS=instance_name=\"${telegraf_tag_instance_name}\":type=\"${telegraf_tag_type}\":host_ip=\"$private_ipv4\" \
          governmentpaas/docker-telegraf
        ExecStop=/usr/bin/docker stop -t 2 telegraf

        [Install]
        WantedBy=local.target

    - name: sentinel.service
      command: start
      enable: true
      content: |
        [Unit]
        Description=Sentinel container
        Requires=docker.service
        After=docker.service

        [Service]
        Restart=always
        ExecStart=/usr/bin/docker run \
          --name sentinel \
          -p 26379:26379 \
          combor/docker-sentinel
        ExecStop=/usr/bin/docker stop -t 2 sentinel

        [Install]
        WantedBy=local.target
