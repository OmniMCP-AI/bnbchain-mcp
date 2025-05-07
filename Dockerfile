# 使用支持 Bun 的基础镜像（如 node:18 作为替代，直到官方 Bun Docker 镜像广泛可用）
FROM node:18

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 bun.lockb 文件
COPY package.json bun.lockb ./

# 安装 Bun（如果未预装）
RUN npm install -g bun@latest

# 安装项目依赖
RUN bun install

# 复制所有源文件到容器中
COPY . .

# 创建 .env 文件（可从构建时传入 PRIVATE_KEY 等变量）
ARG PRIVATE_KEY
ARG LOG_LEVEL=INFO
ARG PORT=3001

# 替换 .env.example 中的占位符（可选）
RUN echo "PRIVATE_KEY=$PRIVATE_KEY\nLOG_LEVEL=$LOG_LEVEL\nPORT=$PORT" > .env

# 暴露服务端口
EXPOSE $PORT

# 启动开发服务器
CMD ["bun", "dev:sse"]