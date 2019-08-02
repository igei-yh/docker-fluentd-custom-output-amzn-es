FROM fluent/fluentd:latest

RUN ["gem", "install", "fluent-plugin-aws-elasticsearch-service", "--no-rdoc", "--no-ri"]

COPY ./custom-entrypoint.sh /bin/
COPY ./fluentd/conf/fluentd.conf /fluentd/etc/

ENTRYPOINT ["/bin/custom-entrypoint.sh"]
CMD ["fluentd"]
