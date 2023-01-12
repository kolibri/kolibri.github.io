FROM python

COPY ./ /website
WORKDIR "/website"

RUN pip install --no-cache-dir -r ./requirements.txt

#EXPOSE 8009

#CMD [ "python", "./website.py" ]
