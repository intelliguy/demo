echo "Press any keys: Start Cleaning!!"
read -n 1

ps -ef | grep port-forward | grep 5601 | awk '{print $2}' | xargs kill

# remove installed software
for h in fluentbit elastic-resource loki fluent-operator elastic-operator 
do 
  helm delete -n demo $h
done
kubectl delete -f loki-cli.yaml -n demo
kubectl delete ns demo

# remove helm-repo
echo "Press any keys: Remove every repository for helm!!"
read -n 1
helm repo remove loki
helm repo remove elastic
helm repo remove taco
