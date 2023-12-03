FROM python:3.8-slim
WORKDIR /usr/src/app
COPY app.py .
RUN pip install Flask
EXPOSE 80
CMD ["python3", "app.py"]
