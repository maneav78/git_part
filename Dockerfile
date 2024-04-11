FROM python:3.7.7

WORKDIR /app

COPY requirements.txt /app/

RUN pip install -r requirements.txt

COPY . .

RUN chmod +x script.sh

RUN chmod +x wait.sh
