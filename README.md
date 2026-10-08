# UnityDocker: entorno ROS 2 Jazzy para Unity

Imagen Docker con **ROS 2 Jazzy**, el puente **ROS-TCP-Endpoint** y los paquetes del **myCobot** de Elephant Robotics, listos para conectarse con un proyecto de Unity.

> Repositorio complementario (proyecto Unity): **[Practica2ROS2Unity](https://github.com/DiegoMurilloP/Practica2ROS2Unity)**

## Contenido de la imagen

| Elemento | Detalle |
|---|---|
| Base | `ros:jazzy` |
| Locale | `en_US.UTF-8` |
| Workspace | `/ros2_ws` (compilado con `colcon build`) |
| `ros_tcp_endpoint` | [Unity-Technologies/ROS-TCP-Endpoint](https://github.com/Unity-Technologies/ROS-TCP-Endpoint), rama `dev-ros2` |
| `mycobot_ros2` | [elephantrobotics/mycobot_ros2](https://github.com/elephantrobotics/mycobot_ros2) |
| Entrypoint | Hace `source` de `/opt/ros/jazzy` y `/ros2_ws/install` y ejecuta el comando dado |

## Estructura

```
Dockerfile       Define la imagen y compila el workspace
entrypoint.sh    Carga el entorno ROS 2 antes de cada comando
README.md
```

## Requisitos

- Docker Desktop (Windows/macOS) o Docker Engine (Linux)
- Conexión a internet durante el *build* (clona dos repositorios)

## Uso

### Construir

```bash
git clone https://github.com/DiegoMurilloP/UnityDocker.git
cd UnityDocker
docker build -t unity-ros2 .
```

### Ejecutar

```bash
docker run -it --rm --name unity-ros2 -p 10000:10000 unity-ros2
```

`-p 10000:10000` publica el puerto TCP que usa Unity. El comando por defecto es `bash`.

### Iniciar el puente con Unity

Dentro del contenedor:

```bash
ros2 run ros_tcp_endpoint default_server_endpoint --ros-args -p ROS_IP:=0.0.0.0
```

Luego, en Unity (proyecto [Practica2ROS2Unity](https://github.com/DiegoMurilloP/Practica2ROS2Unity)), configura *ROS IP* = `127.0.0.1`, *Port* = `10000` y pulsa Play.

### Abrir más terminales en el mismo contenedor

```bash
docker exec -it unity-ros2 bash
```

El entrypoint no se aplica a `docker exec`; carga el entorno manualmente:

```bash
source /opt/ros/jazzy/setup.bash && source /ros2_ws/install/setup.bash
```

## Verificación

```bash
ros2 pkg list | grep -E "ros_tcp_endpoint|mycobot"
ros2 topic list
ros2 topic echo /joint_states
```

## Personalización

- **Cambiar el comando por defecto**: edita `CMD` en el `Dockerfile` (por ejemplo, para lanzar directamente el endpoint o tu propio nodo).
- **Montar código propio**: `docker run -it --rm -p 10000:10000 -v ${PWD}/mi_pkg:/ros2_ws/src/mi_pkg unity-ros2` y luego `colcon build` dentro del contenedor.
- **Fijar versiones**: los `git clone` apuntan a la rama por defecto; para builds reproducibles añade `git checkout <commit>` o `--branch <tag>`.

## Problemas comunes

| Síntoma | Causa probable | Solución |
|---|---|---|
| Unity no conecta | Puerto no publicado | Ejecutar con `-p 10000:10000` |
| Unity conecta pero no recibe datos | Endpoint escuchando solo en localhost | Usar `-p ROS_IP:=0.0.0.0` |
| `package not found` en `docker exec` | Entorno sin cargar | Hacer `source` manual (ver arriba) |
| Falla `colcon build` | Dependencias de `mycobot_ros2` | Revisar el log del build e instalar con `rosdep install --from-paths src -y --ignore-src` |
| Mensajes `Mycobot*` no reconocidos en Unity | Interfaces no generadas en Unity | *Robotics → Generate ROS Messages* en Unity |

## Convenciones de contribución

- Rama principal: `main`; cambios en ramas `feature/<tema>` / `fix/<tema>`.
- Commits `tipo: descripción` (`feat`, `fix`, `docs`).
- Mantén `entrypoint.sh` con finales de línea **LF** (si se guarda con CRLF en Windows, el contenedor falla con `bad interpreter`).

## Créditos

- [ROS-TCP-Endpoint](https://github.com/Unity-Technologies/ROS-TCP-Endpoint) (Unity Technologies)
- [mycobot_ros2](https://github.com/elephantrobotics/mycobot_ros2) (Elephant Robotics)

## Autor

Diego Murillo, [@DiegoMurilloP](https://github.com/DiegoMurilloP)
