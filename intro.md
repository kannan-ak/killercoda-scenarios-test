Your newly deployed application is crashing because of readiness/liveness probe failures.
Upon investigation, it is found that the application takes 1 minutes to startup but the liveness probe kicks in within 10 seconds and has threshold of 3 consecutive failures.
You are asked to add an startup probe to the application so that it will ensure that application starts fine before it is subjected to readiness/liveness probes.

To-do
- Create a nginx deployment with the following command
`kubectl create deployment nginx-deployment --image nginx:latest --replicas 1`
- Update the deployment with a startup probe