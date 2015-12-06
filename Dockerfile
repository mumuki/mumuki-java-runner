FROM java/openjdk-8-jdk
MANTAINER Franco Leonardo Bulgarelli
RUN wget http://central.maven.org/maven2/org/hamcrest/hamcrest-core/1.2.1/hamcrest-core-1.2.1.jar 
RUN wget http://central.maven.org/maven2/junit/junit/4.12/junit-4.12.jar
