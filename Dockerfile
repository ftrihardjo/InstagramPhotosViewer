FROM ubuntu:xenial
RUN apt-get update
RUN apt-get install -y wget xvfb unzipUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update
RUN apt-get install -y google-chrome-stable
ENV CHROMEDRIVER_VERSION 2.30
ENV CHROMEDRIVER_DIR /chromedriver
RUN mkdir $CHROMEDRIVER_DIR
RUN wget -q --continue -P $CHROMEDRIVER_DIR "http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
RUN unzip $CHROMEDRIVER_DIR/chromedriver* -d $CHROMEDRIVER_DIR
ENV PATH $CHROMEDRIVER_DIR:$PATH
FROM python:3
RUN pip install requests
RUN pip install selenium
RUN pip install pillow
WORKDIR /app
COPY instagram_photos_viewer.py /app/
COPY chromedriver.exe /app/
RUN chmod a+x instagram_photos_viewer.py
RUN chmod a+x chromedriver.exe
ENTRYPOINT  ["./instagram_photos_viewer.py"]