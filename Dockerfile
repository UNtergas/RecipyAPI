FROM python:3.9-alpine3.13
LABEL maintainer="untergas"

ARG DEV=false
#DEFAULT VALUE FOR THE DEV ARGUMENT -> false

ENV PYTHONUNBUFFERED 1
#ENVIRONMENT VARIABLE TO PREVENT PYTHON FROM BUFFERING OUTPUT -> PRINTS OUTPUT IMMEDIATELY

COPY  ./requirements.txt /tmp/requirements.txt
COPY  ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000


RUN python -m venv /py && \ 
    #CREATE A NEW VIRTUAL ENVIRONMENT    
    /py/bin/pip install --upgrade pip && \
    #UPGRADE PIP
    apk add --no-cache postgresql-client && \
    apk add --no-cache --virtual .tmp-build-deps build-base postgresql-dev musl-dev && \
    #INSTALL POSTGRESQL CLIENT AND GROUP TEMPORARY BUILD DEPENDENCIES INTO A VIRTUAL PACKAGE
    /py/bin/pip install -r /tmp/requirements.txt && \
    #INSTALL REQUIREMENTS
    if [ $DEV = "true" ] ; then /py/bin/pip install -r /tmp/requirements.dev.txt ; fi && \
    #INSTALL DEV REQUIREMENTS IF DEV IS TRUE
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    #REMOVE TEMPORARY FILES + VIRTUAL PACKAGE-> keep the image as light as possible
    adduser \
    --disabled-password \
    --no-create-home \
    django-user 
#CREATE A NEW USER CALLED DJANGO-USER -> to run the container as a non-root user 

ENV PATH="/py/bin:$PATH"
#ADD THE VIRTUAL ENVIRONMENT TO THE PATH -> direct access to the python interpreter on the virtual environments
USER django-user