FROM python:3
RUN git clone https://github.com/ftrihardjo/InstagramPhotosViewer.git
RUN pip install requests
RUN pip install selenium
RUN pip install pillow
WORKDIR /InstagramPhotosViewer
RUN sudo chmod a+x instagram_photos_viewer.py
ENTRYPOINT  ["./instagram_photos_viewer.py"]