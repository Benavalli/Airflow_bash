#! Função para verificar se o pacote existe na distro
exists() {
    dpkg -l $1 > /dev/null
    if [ $? -eq 0 ]; then
        echo 'Pacote ' "$1" 'já foi instalado'
    else
        apt-get install $1
    fi
}

#! Função para clonar repositório passado como parâmetro
lazyclone() {
	echo '**Clonando repositório do Airflow.'  
    git clone $1 $2;
    chmod -R 777 $2
    cd $2
}
 
#! Função para verificar se diretório já foi clonado
exists_repo() {
	url=$1
    reponame=$(echo $url | awk -F/ '{print $NF}' | sed -e 's/.git$//')
	repopath=$(find ~ -type d -name $reponame)
	#echo $repopath
	if [ -z "$repopath" ]; then
		 lazyclone $url $reponame       
    else        
        echo '**Repositório do Airflow já existe no sistema.'
        cd $repopath
    fi
}

#! Função para verificar se ambiente virtual existe e iniciá-lo
exist_venv() {			
	if [ ! -d "venv" ]; then
		echo '**Criando ambiente virtual.'
		pyvenv venv
		chmod -R 777 venv
	else
		echo '**Ambiente virtual já existe no sistema.'
	fi
	echo '**Iniciando Ambiente Virtual.'
	#running activate
	. ./venv/bin/activate
	show_python_version
}

show_python_version() {
	pythonversion = $(echo 'A versão do Python em ambiente virtual é ' python --version)
	echo $pythonversion
}

#! Dependencies required to run Airflow
echo '**Verificação de dependências do Airflow.'
exists libmysqlclient-dev
exists python-psycopg2
exists libpq-dev
exists libgeos-dev
exists python-dev
exists python3-dev
exists libffi-dev
exists libssl-dev

#! Clone repositório Airflow, caso o mesmo já exista apenas movemos o diretório
exists_repo https://github.com/apache/incubator-airflow

#! Criando e inicializando ambiente virtual com versão do Python 3.5 dentro do repositório do Airflow 
exist_venv

#pip install -r requirements.txt