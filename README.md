## support-metrics-bundle extension script 

support-metrics-bundle, as packaged below, is an extension to the support-metrics-bundle script which is currently packaged with the confluent platform installation. 

This script attempts to provide an accurate representation of the data which may requested during the course of a support engagement. 

Instructions: 

   1. Add support-metrics-bundle-ext script to the directory which contains the Confluent Platform scripts for starting/stopping services
     *See the Confluent Platform [quick start guide](http://docs.confluent.io/3.0.0/quickstart.html) if you are unsure where these scripts reside

   2. Run the script: ```sudo /usr/bin/support-metrics-bundle-ext script --zookeeper localhost:2181```

Note that the script makes the following assumptions:
   1. JPS has been installed and is present on the PATH 
   
         ```which jps```
   2. User executing the script has sufficient privileges to list the broker process with JPS

	```sudo jps
		12787 SupportedKafka
		12149 QuorumPeerMain
		25871 Jps```


