FROM pytorch/pytorch:1.4-cuda10.1-cudnn7-devel

ARG INTERPRETER
ARG INTERPRETER_VERSION

ENV USER=ubuntu \
    UID=1000 \
    GID=1000 \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y software-properties-common \
    && add-apt-repository ppa:git-core/ppa -y \
    && add-apt-repository ppa:deadsnakes/ppa -y \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
         build-essential \
         openssh-server \
         git \
         locales \
         rsync \
         curl \
         wget \
         iputils-ping \
         telnet \
         screen \
         nano \
         vim \
         ${INTERPRETER} \
         ${INTERPRETER}-distutils \
    && rm -f /etc/ssh/ssh_host_*key* \
    && addgroup --gid "$GID" "$USER" \
    && adduser \
         --disabled-password \
         --gecos "" \
         --ingroup "$USER" \
         --uid "$UID" \
         --shell /bin/bash \
         "$USER" \
    && mkdir -p \
         /run/sshd \
         /home/"$USER"/.ssh \
    && chmod 700 /home/"$USER"/.ssh \
    && chown $USER:$USER -R /home/"$USER" /tmp \
    && rm -rf \
        /var/lib/apt/lists/* \
        /var/cache/debconf \
        /tmp/* \
        /usr/local/bin/pip3 \
        /usr/local/bin/pip \
        /usr/bin/python3 \
    && apt-get clean \
    && ln -s /usr/local/bin/pip${INTERPRETER_VERSION} /usr/local/bin/pip \
    && ln -s /usr/local/bin/pip${INTERPRETER_VERSION} /usr/local/bin/pip3 \
    && ln -s /usr/bin/${INTERPRETER} /usr/bin/python3

COPY sshd_config /home/"$USER"/.ssh/sshd_config
COPY config /home/"$USER"/.ssh/config
COPY bash.bashrc /etc/bash.bashrc

RUN curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py \
    && ${INTERPRETER} /tmp/get-pip.py \
    && ${INTERPRETER} -m pip install tensorflow-gpu==2.2.0 \
    && rm -rf /tmp/get-pip.py

RUN ${INTERPRETER} -m pip install jupyter matplotlib \
    && ${INTERPRETER} -m pip install jupyter_http_over_ws ipykernel==5.1.1 nbformat==4.4.0 \
    && jupyter serverextension enable --py jupyter_http_over_ws

RUN chmod 400 /home/"$USER"/.ssh/config \
    && chown -R $USER:$USER /home/"$USER"/.ssh

EXPOSE 2222 \
       8888 \
       6006

WORKDIR /tmp

USER $USER

CMD ["/bin/sh", "-c", "exit 0"]