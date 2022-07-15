# k8s-ci-cd
This repo is to build Java app from scratch and deploy in EKS

To start Jenkins:
docker run --name jenkins -p 8080:8080 -p 50000:50000 -v /var/jenkins_home jenkins/jenkins
