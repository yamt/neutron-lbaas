#!/bin/bash

set -ex

testenv=${1:-"apiv2"}

if [ "$testenv" = "lbaasv1" ]; then
    testenv="apiv1"
elif [ "$testenv" = "lbaasv2" ]; then
    testenv="apiv2"
fi

export DEVSTACK_LOCAL_CONFIG="enable_plugin neutron-lbaas https://git.openstack.org/openstack/neutron-lbaas"

if [ "$testenv" != "apiv1" ]; then
  # Override enabled services, so we can turn on lbaasv2.
  # While we're at it, disable cinder and swift, since we don't need them.
  s=""
  #s+="c-api,c-bak,c-sch,c-vol,"
  s+="ceilometer-acentral,ceilometer-acompute,ceilometer-alarm-evaluator"
  s+=",ceilometer-alarm-notifier,ceilometer-anotification,ceilometer-api"
  s+=",ceilometer-collector"
  #s+=",cinder"
  s+=",dstat"
  s+=",g-api,g-reg"
  s+=",h-api,h-api-cfn,h-api-cw,h-eng"
  s+=",heat"
  s+=",horizon"
  s+=",key"
  s+=",mysql"
  s+=",n-api,n-cond,n-cpu,n-crt,n-obj,n-sch"
  s+=",q-agt,q-dhcp,q-fwaas,q-l3,q-meta,q-metering,q-svc,q-vpn,quantum"
  s+=",q-lbaasv2"
  s+=",rabbit"
  #s+=",s-account,s-container,s-object,s-proxy"
  s+=",sahara"
  s+=",tempest"
  export OVERRIDE_ENABLED_SERVICES="$s"
fi

$BASE/new/devstack-gate/devstack-vm-gate.sh
