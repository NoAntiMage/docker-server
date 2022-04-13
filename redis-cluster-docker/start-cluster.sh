docker exec -it redis1 redis-cli -a ${passwd} \
--cluster create \
${ip}:${port1} \
${ip}:${port2} \
${ip}:${port3} \
${ip}:${port4} \
${ip}:${port5} \
${ip}:${port6} \
--cluster-replicas 1