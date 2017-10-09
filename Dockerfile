FROM tmaier/docker-compose:17.06

MAINTAINER ludovic.claude@chuv.ch

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

########################################################################################################################
# Install build requirements
########################################################################################################################

RUN apk add --update --no-cache bash build-base git py-pip python python-dev curl \
    && pip install pre-commit==1.3.0 \
    && curl -sSL https://raw.githubusercontent.com/harbur/captain/v1.1.0/install.sh | bash \
    && rm -rf /var/cache/apk/* /tmp/*

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="hbpmip/docker-compose-for-ci" \
      org.label-schema.description="Docker compose for continuous integration build" \
      org.label-schema.url="https://github.com/HBPMedical/docker-compose-for-ci" \
      org.label-schema.vcs-type="git" \
      org.label-schema.vcs-url="https://github.com/HBPMedical/docker-compose-for-ci" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.version="$VERSION" \
      org.label-schema.vendor="LREN CHUV" \
      org.label-schema.license="Apache2.0" \
      org.label-schema.docker.dockerfile="Dockerfile" \
      org.label-schema.schema-version="1.0"
