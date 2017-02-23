channel channel01 create -dst-addr ryu01 -protocol tcp
controller controller01 create -channel channel01 -role equal -connection-type main

interface interface1 create -type ethernet-dpdk-phy -device virtio_user0,path=/tmp/dpdk/vhost0
interface interface2 create -type ethernet-dpdk-phy -device virtio_user1,path=/tmp/dpdk/vhost1
interface interface3 create -type ethernet-dpdk-phy -device virtio_user2,path=/tmp/dpdk/vhost2

port port01 create -interface interface1
port port02 create -interface interface2
port port03 create -interface interface3

bridge bridge01 create -controller controller01 -port port01 1 -port port02 2 -port port03 3 -dpid 0x2
bridge bridge01 enable
