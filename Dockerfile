FROM jayess/tempus-base

USER root
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -qy install gdb
RUN /venv/bin/pip install --upgrade --no-cache-dir \
        https://github.com/jsza/getoverhere/zipball/master

USER steam
ENV HOME /home/steam
ENV STEAMCMD $HOME/steamcmd

COPY ./update_css.txt $STEAMCMD/update_css.txt
COPY ./run_css.sh $STEAMCMD/run_css.sh

RUN $STEAMCMD/steamcmd.sh +quit

ENTRYPOINT ["/home/steam/steamcmd/run_css.sh"]
