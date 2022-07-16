FROM tomcat AS tomcat
COPY target/wwp-1.0.0.war /usr/local/tomcat/webapps/wwp-1.0.0.war
EXPOSE 8080

FROM ubuntu AS helm
RUN apt-get install gcloud* -y && apt-get install helm -y && apt-get install kubectl -y