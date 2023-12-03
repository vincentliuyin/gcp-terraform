FROM python:3.8-slim
WORKDIR /usr/src/app
COPY app.py .
RUN chmod 755 app.py
RUN pip install Flask
RUN useradd -u 1000 -m appuser
RUN chown -R appuser:appuser /usr/src/app
USER 1000
EXPOSE 8080
CMD ["python3", "app.py"]
