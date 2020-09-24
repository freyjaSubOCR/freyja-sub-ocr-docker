# Freyja subtitle OCR trainer docker

A pre-built training environment for Freyja subtitle OCR trainer.

## Introduction

This docker image contains:

- compiled binaries of [vapoursynth](https://github.com/vapoursynth/vapoursynth), [ffms2](https://github.com/FFMS/ffms2) and [fmtconv](https://github.com/EleonoreMizo/fmtconv) for training data reading.

- CUDA and cuDNN for GPU accelerated training.

- Jupyter Notebook and TensorBoard for easy remote access and training progress monitoring.

- Other required python packages for training.

## Usage

After pulling images from <https://hub.docker.com/r/arition/freyja-sub-ocr>, set up [port forwarding](https://docs.docker.com/config/containers/container-networking/) on 8888:8888 for docker, and run following commands in container:

```bash
git clone https://github.com/freyjaSubOCR/freyja-sub-ocr-training # clone training repo
socat TCP-LISTEN:8888,bind=0.0.0.0,reuseaddr,fork TCP:127.0.0.1:8889 & # forward localhost jupyter instance to all interface
jupyter lab # start jupyter instance
```

Now you can access Jupyter instance on <http://localhost:8888>
