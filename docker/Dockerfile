FROM python:3.8-slim

RUN apt-get update  \
    && apt-get install moreutils -y \
    && apt-get install jq -y \
    && pip3 install awscli \
    && pip3 install flask \
    && pip3 install zk_shell

COPY ["backup_scripts/*","entrypoint.sh","./"]

ENTRYPOINT ["./entrypoint.sh"]