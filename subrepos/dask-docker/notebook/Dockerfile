FROM  holdenk/jupyter-hub-magicsingleuser-sample:0.10.2

USER root

RUN apt-get update \
    && apt-get install -yq graphviz git build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN touch /hello_holden

USER $NB_USER

RUN conda install -c conda-forge --yes mamba
RUN mamba install --yes python==3.8.6
RUN (mamba install --yes aiohttp==3.7.1 || pip install aiohttp==3.7.1 )
RUN mamba install --yes \
    python-blosc \
    cytoolz \
    dask==2.30.0 \
    dask-core==2.30.0 \
    lz4 \
    numpy==1.19.2 \
    ipywidgets \
    python-graphviz && \
    mamba install --yes s3fs gcsfs dropboxdrivefs requests dropbox paramiko adlfs pygit2 pyarrow && \
    mamba install --yes bokeh numba llvmlite
RUN (mamba install --yes fastparquet || pip install fastparquet)
RUN (mamba install --yes jupyter-server-proxy || pip install jupyter-server-proxy)
RUN (mamba install --yes dask-labextension==3.0.0 || pip install dask-labextension==3.0.0)
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager dask-labextension@3.0.0 @jupyterlab/server-proxy \
    && jupyter serverextension enable dask-labextension@3.0.0 @jupyterlab/server-proxy \
    && pip install dask-kubernetes==0.11.0 \
    && jupyter lab clean \
    && jlpm cache clean \
    && npm cache clean --force \
    && find /opt/conda/ -type f,l -name '*.a' -delete \
    && find /opt/conda/ -type f,l -name '*.pyc' -delete \
    && find /opt/conda/ -type f,l -name '*.js.map' -delete \
    && find /opt/conda/lib/python*/site-packages/bokeh/server/static -type f,l -name '*.js' -not -name '*.min.js' -delete || echo "no bokeh static files to cleanup" \
    && rm -rf /opt/conda/pkgs

USER root

# Create the /opt/app directory, and assert that Jupyter's NB_UID/NB_GID values
# haven't changed.
RUN mkdir /opt/app \
    && if [ "$NB_UID" != "1000" ] || [ "$NB_GID" != "100" ]; then \
    echo "Jupyter's NB_UID/NB_GID changed, need to update the Dockerfile"; \
    exit 1; \
    fi

# Copy over the example as NB_USER. Unfortuantely we can't use $NB_UID/$NB_GID
# in the `--chown` statement, so we need to hardcode these values.
COPY --chown=1000:100 examples/ /home/$NB_USER/examples
COPY prepare.sh /usr/bin/prepare.sh

ENTRYPOINT ["tini", "--", "/usr/bin/prepare.sh"]
