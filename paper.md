---
title: 'diedactic: Docker Image Evaluation with Docker-slim And Clair To Identify CVEs'
tags:
  - docker
  - clair
  - docker-slim
  - CVE
  - vulnerabilities
  - containers
  - CI/CD
  - SAST
authors:
  - name: Zac Fowler
    orcid: 0000-0002-6288-3270
    affiliation: 1
  - name: Matt Hale, PhD
    orcid: 0000-0002-8433-2744
    affiliation: 2
affiliations:
 - name: Graduate Student, Cyber Security, University of Nebraska at Omaha
   index: 1
 - name: Assistant Professor, School of Interdisciplinary Informatics, University of Nebraska at Omaha
   index: 2
date: 14 August 2020
bibliography: paper.bib

# Optional fields if submitting to a AAS journal too, see this blog post:
# https://blog.joss.theoj.org/2018/12/a-new-collaboration-with-aas-publishing
#aas-doi: 10.3847/xxxxx <- update this with the DOI from AAS once you know it.
#aas-journal: Astrophysical Journal <- The name of the AAS journal.
---

# Summary

Diedactic is an empirical analysis tool that can assist with reducing the attack surface
of container-based application images. Diedactic brings together two open source software (OSS) tools, namely `clair` [@clairgithub] and `docker-slim` [@dockerslimgithub], and provides new utilities for sliming and analyzing resulting images. This paper demonstrates the use of Diedactic using a case study. For the case study, a minimally configured 
"slimming" operation was applied to the ["Official" images](https://hub.docker.com/search?q=&type=image&image_filter=official) available on Docker 
Hub. Diedactic uses a static analysis security tool (SAST) to measure the effects of attack surface reduction for application 
containers.

Findings show that without application-specific configuration, the slimming
operation results in one of three types of application container attack
surface changes, measured by reduction of Common Vulnerabilites and 
Exposures (CVEs):

  1. No reduction in attack surface
  2. Complete reduction in attack surface
  3. Unknown reduction in attack surface

Diedactic along with the results of the case study can help container-based application distributors to
employ practices that encourage "slimming" compatibility for reducing or 
eliminating open CVE vulnerabilities present in images.

# Background

Using dockerized, or more broadly "containerized" solutions for software 
development adds a new layer of complexity to the underlying solution stack.  
Namely, the base image used for a container-based application often includes
a full-sized operating system such as `ubuntu`, `debian`, or the smaller `alpine`.  
Examining the security posture of dockerized applications therefore requires 
an analysis of not only application code but also an inspection of the base 
image on which it is built.

`clair` [@clairgithub] is an open-source software project for finding application container 
vulnerabilities using static analysis. The `clair` database tool creates a 
mapping layer between CVE databases and features present in an application 
container image.  `clair` can be integrated with a public or private 
container registry as part of a CI/CD process or user-triggered scanning
requirement.

`docker-slim` [@dockerslimgithub] is a project that purports to reduce security vulnerabilities 
by removing the unused components of any underlying image on which an 
application container is built.  


# Case Study Methodology

A project environment was created to support a private registry, and a running
instance of the `clair` SAST for containers based on `arminc`'s work for 
localhost development.  A list of "Official" Docker Hub images was created from
the [Docker Hub image browser](https://hub.docker.com/search?q=&type=image&image_filter=official).
Deprecated images, and images that did not have a `latest` tag were excluded from
this work.

A virtual server using 16GB of RAM and 8 CPU cores running Ubuntu Desktop 18.04 LTS
was provisioned with `docker` and supporting developer tools.  The virtual server
was configured to run `clair` alongside a private registry configured to accept TLS
connections using a custom CA and service certificate.  `docker-slim` and `klar` [@klargithub]
binaries were installed as dependencies to the project work.  The command-line
tool `jq` [@jq] was installed to process `.json` reports and log output.

Using a series of scripts available at this project's repository, all images from the 
list are pulled to the server and then "slimmed" using the `docker-slim build` 
command, which by default performs an HTTP probe for non-interactive analysis. The 
list included 163 images as of retrieval on Aug 8, 2020, however the list soon 
became outdated even during subsequent runs only hours later, due to the real-time 
nature of the Docker Hub service.  No effort to configure or optimize the slimming
process was performed; all slimming was executed using default settings to perform 
HTTP probing on any port exposed from within the image itself.  

Once slimmed, each image was pushed to the private registry for analysis by `clair`.
The `klar` tool acts as a client to the `clair` service, avoiding the need to script
cURL based API calls to register, push, and process images.  A script then submits 
both the original images pulled from Docker Hub as well as the slimmed versions 
using `klar`.  The results of the submission are outputted and saved as JSON and 
text-based log files.  Result data includes the name of image, final image size, 
number of layers processed by `clair`, and counts for Unknown, Negligible, Low, 
Medium, and High vulnerabilities.

Data to measure how well the slimming process worked in preserving application
functionality was not collected.  The slimming process performed in this work
may have resulted in non-functional application containers.


# Results

Results of slimming and analysis by `klar` identified three types of vulnerability 
reduction:

  1. No reduction in known CVEs
  2. Reduction in known CVEs
  3. Unknown reduction in CVEs

Type (2) is considered to be success, in terms of the slimming process, though there 
is no indication the application remains fully functional without further testing.

Of the 163 projects selected for inclusion, 149 were still active at the time of 
the scans and met the inclusion criteria. Of those, 81 were slimmed, having an 
average size reduction of 348 MB, and an average reduction of 115 CVEs.
See [a copy of the scanning output](assets/scanning-output.csv) data here.

## No Reduction

In this category, the number of CVEs present in the slimmed version equaled the
number of CVEs present in the original image.  No severity changes were observed
(e.g., if High CVEs changed to Low, etc.), indicating zero reduction in attack 
surface as defined by open CVEs.

Only one image, `nginx`, observed a reduction in size and no reduction in CVEs.
The image size shrunk from 133MB to 11.1MB, while the total CVE count remained
at 94.

## Reduction

The number of CVEs present in the slimmed version was less than CVEs in the 
original image.  In all cases except for the one noted above, not only was there 
a reduction in CVEs, but the slimming process appeared to eliminate *all* CVEs 
from the images.  See Discussion below on possible implications.


## Unknown Reduction

When an error occurred during the slimming operation, no data could be derived
about CVE reduction or measurement.  Contributing factors to a failed slimming
process include a missing entrypoint or having no exposed ports configured.

79 of the 149 apps scanned failed to produce a slimmed version and could not 
be further measured for a reduction in vulnerabilities.

# Discussion

Initially, the image slimming process that resulted in elimination of all CVEs 
created doubt that the tools were functioning properly.  Expanding the list to 
include a variety of image types (middleware such as node, applications such as 
nextcloud), eliminated that concern. The primary driver for reduction in CVEs
during the slimming process is the proper construction of the image by its authors.
Images that include an exposed port with an HTTP interface improved the ability
for the `docker-slim` process to do its job.  However, as in the case with web
applications such as `drupal` and `nextcloud`, the slimming process did not 
capture full application functionality. The slimmed image often failed after
navigating away from the application's home page or installation steps, for
example, without applying additional configuration options to `docker-slim`.

Images did not expose ports by default, such as `ubuntu` and `node` failed
the slimming process entirely.  The slimming process has no visibility into 
the running processes without execution calls from an external trigger, and as 
a result a slimmed version of the image could not be created by the tool.  
Analysis of CVE data in these cases was not possible.

# Conclusions

Docker image maintainers can take advantage of the `docker-slim` tool to 
successfully reduce its attack surface, measured by a reduction in open CVE 
count. Diedactic automates the analysis process, allowing developers and image maintainers to slim their images, analyze them for CVEs, and generate a mitigation-oriented report to direct future development and maintenance work.

# Acknowledgements

Thank you to Dr. Hale for guidance and scoping on this project, and [`arminc`](https://github.com/arminc/clair-local-scan/) for the dockerization of a local `clair` runtime.

# References
