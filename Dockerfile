FROM python as creator

COPY ./ /website
WORKDIR "/website"

RUN pip install --no-cache-dir -r ./requirements.txt

#EXPOSE 8009

#CMD [ "python", "./website.py" ]

FROM nginx as webserver

COPY ./nginx.conf /etc/nginx/nginx.conf

