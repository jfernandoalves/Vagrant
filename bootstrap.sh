echo Instalando repositorios.....
sudo yum -y install -y yum-utils device-mapper-persistent-data lvm2

echo Instalando repositorios.....
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo Instalando repositorios.....
sudo yum-config-manager --enable docker-ce-edge

echo Instalando Docker.....
sudo yum makecache fast

echo Instalando Docker.....
sudo yum -y install docker-ce

echo Iniciando o Docker
sudo systemctl start docker