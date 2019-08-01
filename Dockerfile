FROM fluent/fluentd:latest

RUN ["gem", "install", "fluent-plugin-aws-elasticsearch-service", "--no-rdoc", "--no-ri"]

COPY ./custom-entrypoint.sh /
COPY ./fluentd/conf/fluentd.conf /fluentd/etc/

ENTRYPOINT ["/custom-entrypoint.sh"]
CMD ["fluentd"]
