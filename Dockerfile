FROM lilith-registry.cn-shanghai.cr.aliyuncs.com/platform/immt_base:1.0.1
ARG APP_VSN=v1
ARG MIX_ENV=dev

ENV HEX_MIRROR=http://hexpm.upyun.com
ENV HEX_CDN=http://hexpm.upyun.com

WORKDIR /app
ADD . .

SHELL ["/bin/bash", "-c"]

# 执行运行环境相关脚本
RUN echo "MIX_ENV is ${MIX_ENV}"; \
    echo "export MIX_ENV=${MIX_ENV}" >> ~/.bashrc; \
    echo ${MIX_ENV} && echo ${APP_VSN} && echo -e "${APP_VSN}\n`date +'%F %T'`\n" > /app/.version.txt

RUN source ~/.bashrc; \
    export DEBUG=1; \
    cd /app && mix deps.get && mix deps.compile && mix.compile

EXPOSE 8888/tcp

ENTRYPOINT ["/app/entrypoint.sh"]