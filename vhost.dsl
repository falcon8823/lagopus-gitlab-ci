channel channel01 create -dst-addr ryu01 -protocol tcp
controller controller01 create -channel channel01 -role equal -connection-type main

interface interface1 create -type ethernet-dpdk-phy -device eth_vhost0,iface=/tmp/dpdk/vhost0
interface interface2 create -type ethernet-dpdk-phy -device eth_vhost1,iface=/tmp/dpdk/vhost1
interface interface3 create -type ethernet-dpdk-phy -device eth_vhost2,iface=/tmp/dpdk/vhost2

port port01 create -interface interface1
port port02 create -interface interface2
port port03 create -interface interface3

bridge bridge01 create -controller controller01 -port port01 1 -port port02 2 -port port03 3 -dpid 0x1
bridge bridge01 enable
