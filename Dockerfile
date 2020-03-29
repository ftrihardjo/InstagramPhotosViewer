
This article is about CodeShip Pro.
Browser Testing
You will need roughly 5 minutes to read this article.

Xvfb
Chrome
Headless Chrome
Firefox
Selenium Server
Notes And Known Issues
Chrome Crashing
Pro Resources
With CodeShip Pro you have many different options to set up browser testing. The following sections describe how you can install different browsers. Please check the documentation for the language/framework you are using for specifics on how to test with your browser.

Xvfb
Before going into the details of setting up various browsers make sure to include Xvfb in your build. Running Xvfb before your browser sets up a virtual display the GUI of the various browsers can use.

Add the following to your Dockerfile to make sure Xvfb is properly started. If you use a non-Debian based Linux distribution please install the Xvfb package through the available package manager.

RUN apt-get install -y xvfb
# The server will listen for connections as server number 1 and screen 0 will be depth 16 1600x1200
Xvfb :1 -screen 0 1600x1200x16 &
export DISPLAY=:1.0
Now you can start any browser that needs a screen available.

Chrome
To get the latest version of Google Chrome simply install it from their Debian repository in your Dockerfile. Additionally you need to install ChromeDriver if you want to use Selenium with Chrome.

# Starting from Ubuntu Xenial
FROM ubuntu:xenial

# We need wget to set up the PPA, Xvfb to have a virtual screen and unzip to extract ChromeDriver
RUN apt-get update
RUN apt-get install -y wget xvfb unzip

# Set up the Chrome PPA
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

# Update the package list and install Chrome
RUN apt-get update
RUN apt-get install -y google-chrome-stable

# Set up ChromeDriver environment variables
ENV CHROMEDRIVER_VERSION 2.30
ENV CHROMEDRIVER_DIR /chromedriver

# Download and install ChromeDriver
RUN mkdir $CHROMEDRIVER_DIR
RUN wget -q --continue -P $CHROMEDRIVER_DIR "http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
RUN unzip $CHROMEDRIVER_DIR/chromedriver* -d $CHROMEDRIVER_DIR

# Put ChromeDriver into the PATH
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