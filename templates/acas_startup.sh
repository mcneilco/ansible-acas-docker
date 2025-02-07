#!/bin/bash
echo `date`
echo "docker down"
docker compose down
docker compose up -d --build
echo "waiting for initial acas startup to complete"
docker compose logs -f --tail 0 acas | while read -r line; do
	if echo "$line" | grep -q "Bootstrap called successfully"; then
		echo "ACAS startup string detected in logs: $line"
		# Start the new container (using docker run or docker start)
		docker compose restart acas
		echo "ACAS restarted, waiting"
		break
	fi
done
echo "waiting for acas restart to complete"
docker compose logs -f --tail 0 acas | while read -r line; do
	if echo "$line" | grep -q "Bootstrap called successfully"; then
		echo "ACAS startup string detected in logs: $line"
		# Start the new container (using docker run or docker start)
		docker compose restart rservices
		# Optional: Exit the monitoring after starting the new container
		echo "rsevices restarted, done"
		break
	fi
done
echo "restart madness all done"
echo `date`
exit 0
