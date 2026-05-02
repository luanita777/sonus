#Instrucciones de Ejecución

Para ejecutar el proyecto se deben seguir los siguientes pasos.

### 1. Clonar el proyecto del repositorio:
       `$ git clone https://github.com/luanita777/sonus.git`
      
### 2. Ejecutar en la terminal en la raíz del proyecto: 
       `$ sudo docker build -t sonus-test-app .`
### 3. Una vez que docker termine de instalar las dependencias, crear la imagen, compilar y testear.
###    Ejecutar:
       `$ sudo docker run --rm \
          -e DISPLAY=$DISPLAY \
          -e ADW_DEBUG_COLOR_SCHEME=prefer-dark \
          -v /tmp/.X11-unix:/tmp/.X11-unix \
          -v $HOME:/home/host_home \
          --device /dev/dri \
          sonus-test-app \
         ./build/sonus /home/host_home/ruta/al/directorio/con/la/musica
       `
