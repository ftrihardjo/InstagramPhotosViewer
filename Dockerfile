FROM python:3
RUN pip install requests
RUN pip install selenium
RUN pip install pillow
RUN chmod a+x linkextractor.py
ENTRYPOINT  ["./Instagram_Photos_Viewer.py"]