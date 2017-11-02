FROM java:openjdk-8-jdk-alpine
MAINTAINER Franco Leonardo Bulgarelli
RUN wget http://central.maven.org/maven2/org/hamcrest/hamcrest-core/1.2.1/hamcrest-core-1.2.1.jar
RUN wget http://central.maven.org/maven2/junit/junit/4.12/junit-4.12.jar
RUN wget http://central.maven.org/maven2/org/apache/commons/commons-text/1.1/commons-text-1.1.jar
RUN wget http://central.maven.org/maven2/org/apache/commons/commons-lang3/3.5/commons-lang3-3.5.jar


COPY runjunit /bin/runjunit
RUN chmod u+x /bin/runjunit
