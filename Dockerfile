FROM nvidia/cuda:10.2-cudnn7-runtime-centos8

RUN dnf -y install 'dnf-command(config-manager)' && \
    dnf -y config-manager --enable PowerTools && \
    dnf -y install --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf -y install --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm && \
    rm -rf /var/cache/dnf/*

RUN dnf -y install git python3 python3-Cython ffmpeg libass zimg && \
    rm -rf /var/cache/dnf/*

RUN dnf -y install python3-devel ffmpeg-devel libass-devel zimg-devel autoconf automake libtool gcc gcc-c++ yasm make && \
    rm -rf /var/cache/dnf/* && \
    git clone https://github.com/vapoursynth/vapoursynth.git && \
    cd vapoursynth && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf vapoursynth

ENV LD_LIBRARY_PATH /usr/local/lib:${LD_LIBRARY_PATH}

RUN git clone https://github.com/EleonoreMizo/fmtconv && \
    cd fmtconv/build/unix && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    cd / && \
    rm -rf fmtconv

RUN git clone https://github.com/FFMS/ffms2 && \
    cd ffms2 && \
    ./autogen.sh && \
    make && \
    make install && \
    cd / && \
    rm -rf ffms2

RUN dnf -y install nodejs && \
    rm -rf /var/cache/dnf/*

RUN pip3 --no-cache-dir install --upgrade pip

# tensorboard==2.2 has a breaking change that prevents jupyter_tensorboard==0.2.0 to function correctly
# See more on: https://github.com/lspvic/jupyter_tensorboard/pull/63
RUN pip3 --no-cache-dir install VapourSynth numpy tensorboard==2.1 jupyter jupyterlab torch torchvision jupyter-tensorboard pytorch-ignite ipywidgets Pillow Vizer matplotlib ipympl numba && \
    jupyter nbextension enable --py widgetsnbextension && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
    jupyter labextension install jupyter-matplotlib && \
    jupyter labextension install jupyterlab_tensorboard && \
    jupyter lab build -y && \
    jupyter lab clean -y && \
    npm cache clean --force && \
    rm -rf "/root/.cache/yarn" && \
    rm -rf "/root/.node-gyp"

RUN dnf -y remove python3-devel ffmpeg-devel libass-devel zimg-devel autoconf automake libtool gcc gcc-c++ yasm make && \ 
    rm -rf /var/cache/dnf/*

RUN dnf -y install net-tools socat && \
    rm -rf /var/cache/dnf/*

ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="100"

ENV NB_USER=$NB_USER \
    NB_UID=$NB_UID \
    NB_GID=$NB_GID

RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER

RUN mv /root/.jupyter /home/$NB_USER/ && \
    mv /root/.local /home/$NB_USER/ && \
    chgrp -R $NB_GID /home/$NB_USER && \
    chmod -R g+rwX /home/$NB_USER && \
    chgrp -R $NB_GID /usr/local/share/jupyter && \
    chmod -R g+rwX /usr/local/share/jupyter

ENV HOME=/home/$NB_USER
USER $NB_UID
WORKDIR $HOME