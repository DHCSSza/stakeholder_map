
FROM rocker/r-ver:4.1.3

LABEL maintainer="Anne Treasure"

RUN mkdir scripts

COPY *.R scripts/

RUN Rscript scripts/[filename].R # to add filename
