# 基于 NVIDIA CUDA 12.1.0 开发版镜像，使用 Ubuntu 20.04 作为基础系统
FROM nvidia/cuda:12.1.0-devel-ubuntu20.04

# 避免 apt-get 安装过程中的交互提示
ARG DEBIAN_FRONTEND=noninteractive

# 安装必要的工具，清理缓存以减小镜像体积
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 下载并安装 Miniconda，设置环境变量
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH="/root/miniconda3/bin:${PATH}"

# 创建 Python 3.10 的虚拟环境
RUN conda create -n myenv python=3.10

# 激活虚拟环境，使用新的 SHELL 环境
SHELL ["conda", "run", "-n", "myenv", "/bin/bash", "-c"]

# 设置工作目录
WORKDIR /app

# 先复制 requirements.txt 以利用 Docker 缓存
COPY requirements.txt .

# 安装项目依赖，避免缓存以减小镜像体积
RUN pip install --no-cache-dir -r requirements.txt

# 复制项目文件和模型文件到容器中
COPY . .

# 暴露端口（根据 app.py 中的端口设置，默认 5000）
EXPOSE 5000

# 启动命令，运行 app.py 并指定模型路径为 /app/models
CMD ["python", "app.py", "--model-path", "/app/models"]
