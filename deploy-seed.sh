#!/usr/bin/env bash

# MLA components namespace
MLA_NS=mla

echo "Adding Helm repos"
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add bitnami https://charts.bitnami.com/bitnami

echo ""
echo "Installing Cassandra"
helm --namespace ${MLA_NS} upgrade --atomic --create-namespace --install cassandra bitnami/cassandra --values config/cassandra/values.yaml

echo ""
echo "Installing Loki"
helm --namespace ${MLA_NS} upgrade --atomic --create-namespace --install loki-distributed charts/loki-distributed --values config/loki/values.yaml

echo ""
echo "Installing Grafana"
helm --namespace ${MLA_NS} upgrade --atomic --create-namespace --install grafana grafana/grafana --values config/grafana/values.yaml


echo ""
echo "Installing a Gateway for cluster-xyz"
helm --namespace cluster-xyz upgrade --atomic --create-namespace --install mla-gw charts/gateway --set mla.namespace=${MLA_NS}

echo ""
echo "Installing Promtail"
helm --namespace promtail upgrade --atomic --create-namespace --install promtail grafana/promtail --set config.lokiAddress=http://mla-gateway.cluster-xyz.svc.cluster.local/loki/api/v1/push
