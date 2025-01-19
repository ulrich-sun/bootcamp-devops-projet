FROM python:3.6-alpine
LABEL maintainer="Ulrich NOUMSI"
WORKDIR /opt
RUN pip install flask==2.0.1
COPY . /opt/
EXPOSE 8080
ENV ODOO_URL="https://www.odoo.com/"
ENV PGADMIN_URL="https://www.pgadmin.org/"
ENTRYPOINT [ "python", "app.py" ]
