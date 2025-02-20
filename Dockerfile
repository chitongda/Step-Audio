# 基于 Python 3.10 的官方镜像作为基础镜像
FROM python:3.10

# 设置工作目录
WORKDIR /app

# 复制当前目录下的所有文件到工作目录
COPY . .

# 更新 pip 并安装必要的依赖
RUN pip install --upgrade pip

# 安装 PyTorch 2.3 支持 CUDA 12.1
RUN pip install torch==2.3.1+cu121 torchvision==0.18.1+cu121 torchaudio==2.3.1 --index-url https://download.pytorch.org/whl/cu121

# 安装其他可能需要的依赖，这里假设项目有一个 requirements.txt 文件
# 如果没有，可以删除这一行或者手动添加需要的依赖
RUN pip install -r requirements.txt

# 设置环境变量（如果有需要）
# 例如，如果项目需要设置 PYTHONPATH
# ENV PYTHONPATH /app

# 暴露端口（如果项目需要）
# EXPOSE 8080

# 定义容器启动时执行的命令
# 这里假设项目有一个 main.py 文件作为入口点
# 如果项目的启动方式不同，请修改这一行
CMD ["python", "main.py"]