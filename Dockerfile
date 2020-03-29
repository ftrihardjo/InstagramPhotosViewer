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