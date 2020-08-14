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
    orcid: 0000-0003-0872-7098
    affiliation: 1
  - name: Matt Hale, PhD
    affiliation: 2
affiliations:
 - name: Graduate Student, Cyber Security, University of Nebraska at Omaha
   index: 1
 - name: Associate Professor, School of Interdisciplinary Informatics, University of Nebraska at Omaha
   index: 2
date: 14 August 2020
bibliography: paper.bib

# Optional fields if submitting to a AAS journal too, see this blog post:
# https://blog.joss.theoj.org/2018/12/a-new-collaboration-with-aas-publishing
#aas-doi: 10.3847/xxxxx <- update this with the DOI from AAS once you know it.
#aas-journal: Astrophysical Journal <- The name of the AAS journal.
---

# Summary

This project provides an empirical analysis of reducing the attack surface
of container-based application images using the `docker-slim` toolset.  Results
include a categorization of outcome when using a minimally configured slimming
operation against the ["Official" images](https://hub.docker.com/search?q=&type=image&image_filter=official) available on Docker Hub, using the `clair`
static analysis security tool for application containers.

Findings show that without application-specific configuration, the slimming
operation results in one of three types of application container attack
surface changes, as measured by reduction of CVEs:

  a) No reduction in attack surface
  b) Complete reduction in attack surface
  c) Unknown reduction in attack surface

Results of this work can help container-based application distributors to
employ practices that encourage compatibility with the `docker-slim` tooling
to reduce or eliminate open CVE vulnerabilities present in images.

# Background

Using dockerized, or more broadly "containerized" solutions for software 
development adds a new layer of technology to the underlying solution stack.  
Namely, the base image used for a container-based application often includes
a full-sized operating system such as `ubuntu`, `debian`, or `alpine`.  
Examining the security posture of dockerized applications therefore requires 
an analysis of not only application code but also an inspection of the base 
image on which it is built.

[`clair`](https://github.com/quay/clair) is an open-source software project for finding application container 
vulnerabilities using static analysis. The `clair` database tool creates a 
mapping layer between CVE databases and features present in an application 
container image.  `clair` can be integrated with a public or private 
container registry as part of a CI/CD process or user-triggered scanning
requirement.

[`docker-slim`](https://github.com/docker-slim/docker-slim) is a project that purports to reduce security vulnerabilities 
by removing the unused components of any underlying image on which an 
application container is built.  


# Methods

A project environment was created to support a private registry, and a running
instance of the `clair` SAST for containers based on `arminc`'s work for 
localhost development.  A list of "Official" Docker Hub images was created from
the [online listing](https://hub.docker.com/search?q=&type=image&image_filter=official).  

A virtual server using 16GB of RAM and 8 CPU cores running Ubuntu Desktop 18.04 LTS
was provisioned with `docker` and supporting developer tools.  The virtual server
was configured to run `clair` alongside a private registry configured to accept TLS
connections using a custom CA and service certificate.  `docker-slim` and `klar` 
binaries were installed as dependencies to the project work.

Using a series of scripts available at the project repository, all images from the 
list are pulled to the server and then 'slimmed' using the `docker-slim build` 
command.  No effort to configure or optimize the image was performed; all 
slimming was executed using default settings to perform HTTP proving on 
any port exposed from within the image.  

Once slimmed, each image was pushed to the private registry for analysis by `clair`.
The `klar` tool acts as a client to the `clair` service, avoiding the need to script
cURL based API calls to process images.  A script then submits both the original images
pulled from Docker Hub as well as the slimmed versions using `klar`.  The results of 
the submission are outputted and saved as JSON and text-based log files.  Result data
includes the name of image, final image size, number of layers processed by `clair`, 
and counts for Unknown, Negligible, Low, Medium, and High vulnerabilities. 

# Results





# Citations (example area)

Citations to entries in paper.bib should be in
[rMarkdown](http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html)
format.

If you want to cite a software repository URL (e.g. something on GitHub without a preferred
citation) then you can do it with the example BibTeX entry below for @fidgit.

For a quick reference, the following citation commands can be used:
- `@author:2001`  ->  "Author et al. (2001)"
- `[@author:2001]` -> "(Author et al., 2001)"
- `[@author1:2001; @author2:2001]` -> "(Author1 et al., 2001; Author2 et al., 2002)"

# Figures - example area

Figures can be included like this:
![Caption for example figure.\label{fig:example}](figure.png)
and referenced from text using \autoref{fig:example}.

Fenced code blocks are rendered with syntax highlighting:
```python
for n in range(10):
    yield f(n)
```	

# Acknowledgements

Thank you to Dr. Hale for guidance and scoping on this project, and [`arminc`](https://github.com/arminc/clair-local-scan/) for the dockerization of a local `clair` runtime.

# References
