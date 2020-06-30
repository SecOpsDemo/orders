# Dockerfile

FROM openjdk:8-jre-alpine

ENV	SERVICE_USER=myuser \
	SERVICE_UID=10001 \
	SERVICE_GROUP=mygroup \
	SERVICE_GID=10001

RUN	addgroup -g ${SERVICE_GID} ${SERVICE_GROUP} && \
	adduser -g "${SERVICE_NAME} user" -D -H -G ${SERVICE_GROUP} -s /sbin/nologin -u ${SERVICE_UID} ${SERVICE_USER} && \
	apk add --no-cache bash curl
# RUN apk add --no-cache bash curl

ENV JAVA_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap"
 
WORKDIR /data
EXPOSE 8082
COPY ./target/*.jar /data/ROOT.jar

RUN	chmod +x /app && \
	chown -R ${SERVICE_USER}:${SERVICE_GROUP} /app && \
	setcap 'cap_net_bind_service=+ep' /app

USER ${SERVICE_USER}

ENTRYPOINT exec java $JAVA_OPTS -jar ROOT.jar
