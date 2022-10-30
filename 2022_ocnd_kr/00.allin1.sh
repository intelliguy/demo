# add loki helm-repo 
helm repo add loki https://grafana.github.io/helm-charts
helm repo add elastic https://helm.elastic.co
helm repo add taco https://openinfradev.github.io/helm-repo

# check charts in loki repo
# helm search repo loki | grep ^loki
# helm search repo elastic | grep ^elastic

echo "Press any keys: Install loki and elasticsearch/kibana!!"
read -n 1
kubectl create ns demo
helm install -n demo loki loki/loki  --version 2.8.1

helm install -n demo elastic-operator elastic/eck-operator --version 1.8.0
helm install -n demo elastic-resource taco/eck-resource -f eck-resource-vo.yaml

watch kubectl get all -n demo
nohup kubectl port-forward -n demo service/eck-kibana-kb-http 5601:5601 &

kubectl exec -itn demo loki-cli sh

echo "Press any keys: Install fluentbit!!"
read -n 1
kubectl apply -f loki-cli.yaml -n demo
helm install -n demo fluent-operator taco/fluent-operator
helm install -n demo fluentbit taco/fluentbit-resource -f demo-simplest.yaml
watch kubectl get po -n demo

kubectl exec -itn demo loki-cli sh
