FROM python:3
RUN pip install requests
RUN pip install selenium
RUN pip install pillow
RUN chmod a+x Instagram_Photos_Viewer.py
ENTRYPOINT  ["./instagram_photos_viewer.py"]