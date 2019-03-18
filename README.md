# aws-infosec

The Information Security resources in AWS

These are Terraform scripts for building out the various pieces of the Information Security environment in AWS.

To build the images, we use [Packer](https://packer.io/)


### EC2 Instances

 * management - jumpbox, puppetmaster, [terraformer](https://www.terraform.io/)
 * dfir - [grr](https://github.com/google/grr), [hive](https://thehive-project.org/), [cortex](https://thehive-project.org/), [misp](https://github.com/misp/misp), [fleet](https://github.com/kolide/fleet)
 * product security - [anchore](https://anchore.com/), [sonarqube](https://www.sonarqube.org/), [deptrack](https://dependencytrack.org/), burp enterprise
 * ops - [vsaq](https://github.com/google/vsaq.git), [flashpaper](https://github.com/rawdigits/go-flashpaper.git), mailserver, [scoutsuite](https://github.com/nccgroup/ScoutSuite), [vulnreport](http://vulnreport.io/), [securitymonkey](https://github.com/Netflix/security_monkey)
 * proxy - HAProxy for everything
 * scanners - nessus and burp scanners


### RDS

 * grr
 * deptrack
 * burpsuite enterprise
 * sonarqube
 * misp
 * fleet
 * vulnreport
