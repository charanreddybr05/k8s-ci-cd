FROM tomcat AS tomcat
COPY target/wwp-1.0.0.war /usr/local/tomcat/webapps/wwp-1.0.0.war
EXPOSE 8080

FROM ubuntu AS helm
RUN apt-get install gcloud* -y && apt-get install helm -y && apt-get install kubectl -y

# docker build -t apache_image:1.0 .
# FROM ubuntu 
# RUN apt update -y
# RUN apt install –y apache2 
# RUN apt install –y apache2-utils 
# RUN apt clean 
# EXPOSE 80 CMD [“apache2ctl”, “-D”, “FOREGROUND”]

#scratch image is empty image, used to build base images(busybox etc) or super minimal images(that contain only a single binary and whatever it requires, such as hello-world)
#Using the scratch “image”, the very next command in the Dockerfile to be the first filesystem layer in your image.
#we can't pull, run ot tag "scratch" image. We can only refer it in Dockerfile
FROM scratch 
COPY hello /
CMD ["/hello"]