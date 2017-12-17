FROM debian:stretch

ARG WD="/srv"
ARG SRC="${WD}/src"

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y socat python3 && \
    useradd -s /bin/nologin chall

WORKDIR $WD

# Compilation

ADD src/ "$SRC/"
RUN apt-get install -y gcc && \
    gcc "$SRC/changebyone.c" -o changebyone && \
    cp "$SRC/changebyone.py" . && \
    chmod 755 "$WD/changebyone.py" "$WD/changebyone" && \
    rm -rf "$SRC" && \
    apt-get purge -y --auto-remove gcc

# Preparation
EXPOSE 5796

# Prepare flag
ADD flag "${WD}/passwd"
RUN chmod 444 "$WD/passwd"

CMD socat TCP-LISTEN:5796,fork EXEC:"python3 /srv/changebyone.py",su=chall,stderr
