FROM koalaman/shellcheck:v0.6.0 as shellcheck

FROM tmaier/docker-compose:18.09

MAINTAINER ludovic.claude@chuv.ch

########################################################################################################################
# Install build requirements
########################################################################################################################

RUN apk add --update --no-cache bash build-base git py-pip python python-dev curl openssh sudo jq \
    && pip install pre-commit==1.15.1 \
    && rm -rf /var/cache/apk/* /tmp/*

COPY --from=shellcheck /bin/shellcheck /usr/bin/shellcheck

# Make sure PATH includes ~/.local/bin
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=839155
RUN echo 'PATH="$HOME/.local/bin:$PATH"' >> /etc/profile.d/user-local-path.sh

# Set timezone to UTC by default
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

# Use unicode
ENV LANG=C.UTF-8

RUN addgroup --gid 3434 circleci \
  && adduser -u 3434 -G circleci -s /bin/bash -D circleci \
  && mkdir -p /etc/sudoers.d \
  && echo 'circleci ALL=NOPASSWD: ALL' >> /etc/sudoers.d/50-circleci

USER circleci

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

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
