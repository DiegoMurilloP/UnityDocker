# Imagen base de ROS 2 Jazzy
FROM ros:jazzy

# Configurar el locale y dependencias básicas
RUN apt-get update && apt-get install -y \
    locales git python3-pip && \
    locale-gen en_US en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Crear el workspace
WORKDIR /ros2_ws/src

# Clonar repositorios Git
RUN git clone -b dev-ros2 https://github.com/Unity-Technologies/ROS-TCP-Endpoint.git ros_tcp_endpoint && \
    git clone https://github.com/DiegoMurilloP/Practica3ROS2Unity.git Practica3ROS2Unity && \
    git clone https://github.com/DiegoMurilloP/Practica2ROS2Unity.git Practica2ROS2Unity

# Volver a la raíz del workspace y compilar
WORKDIR /ros2_ws
RUN . /opt/ros/jazzy/setup.sh && colcon build

# Copiar entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Usar entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Comando por defecto
CMD ["bash"]
