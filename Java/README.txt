Download the Java Cryptography Extension from here 207
Unzip the contents - should contain a readme and two jars.
Copy the jars to JAVA_HOME/jre/lib/security or JAVA_HOME/lib/security For me this was
cp *jar /usr/lib/jvm/zulu-embedded-8-armhf/jre/lib/security
cp *jar /usr/lib/jvm/zulu-embedded-8-armhf/lib/security
restart your rpi.
