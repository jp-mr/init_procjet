#!/bin/bash
#
# init_project.sh - Configurar projetos django no linux
# 
# Autor     : João Paulo    <jprnogueira@yahoo.com.br>
# Co-autor  : Michel        <michel.rodrigues86@yahoo.com.br>
# Manutenção: Ambos
#
#--------------------------------------------------------------------
#
# Este programa configura toda a parte inicial de um projeto django
# desde a criação da pasta do projeto na HOME do sistema linux até
# a instalação e configurações basicas do django.
#
#--------------------------------------------------------------------
#
# Histórico:
#
#   201610081429: João Paulo, Agosto de 2016
#       - Configurações de ambiantes
#
#   201611080746: João Paulo, Agosto de 2016
#       - Implementação das pastas no diretorio HOME
#       - Destaque de alguns avisos importantes
#       - Adicionei o -y no comando su
#       - Implementação de verificação de variaveis globais
#       - retirada do comando su
#       
#   201624081508: João Paulo, Agosto de 2016
#       - Implementação das funções django() e ambience()
#
#   201625081156: João Paulo, Agosto de 2016
#       - Alterações na função ambience()
#       - TODO problemas com os comando mkvirtulaenv e workon
#       - XXX Função django esta comentada devido aos problemas acima 

DIRETORIO="$2"
VERSAO_DJANGO="$3"

#-----------------------------[FUNÇÕES]----------------------------

django(){       

   # mkvirtualenv  "$DIRETORIO"  # criar um ambiente virtual.
   # workon "$DIRETORIO"  # ativar o ambiente virtual.
    

    # conferir se versão foi fornecida
    if [ "$VERSAO_DJANGO" ]
        then
            pip install django=="$VERSAO_DJANGO" # instalar o django. 

    else
        pip install django  # instala a ultima versão estável
    fi

#-----------------------[ projeto django]----------------------------
    
    django-admin.py startproject "$2" # iniciar projeto django

    # cd "$DIRETORIO"

    python manage.py makemigrations # criar as tabelas.
    
    python manage.py migrate        # enviar para o banco de dados.
# XXX O comando syncdb não existe mais.
}

ambience(){

    [ "$DIRETORIO" ]||{
        echo "Ops! Esqueceu colocar o nome do AMBIENTE."
        exit 1
    }
            
    mkdir -p "$DIRETORIO" . 
    
    cd "$HOME/$DIRETORIO" 

#-----------------[criar e ativar ambiente virtual]------------------

# XXX virtualwrapper é instalado junto com o virtualenv.

   # mkvirtualenv  "$DIRETORIO"  # criar um ambiente virtual.
   # workon "$DIRETORIO"  # ativar o ambiente virtual.

# XXX O comando workon sozinho lista os ambientes disponíveis.

}

#-----------------------------[ menu ]--------------------------------

[ "$1" ] || {

    echo 
    echo -e "\033[1mNOME \033[m" 
    echo "      $(basename "$0")"
    echo 
    echo -e "\033[1mSINOPSES \033[m"
    echo -e "      \033[1m./$(basename "$0")\033[m [OPCOES]"
    echo -e "      \033[1m./$(basename "$0")\033[m [\033[1m-a\033[m] NOME_DO_DIRETORIO [VESAO_OPCIONAL_DJANGO]"
    echo
    echo -e "\033[1mOPCOES \033[m"
    echo "      -a, --ambience  Inserir nome da pasta do projeto (versao django opcional"
    echo "      -V, --version   Mostrar a versao do programa"
    echo
}

#-------------------------------[ opções ]----------------------------

while test -n "$1"
do
    case "$1" in

        # Opções que ligam/desligam chaves

        -a | --ambience)
           
                    ambience 
                    #django 

            exit 0
        ;;

        -V | --version)
            echo -n $(basename "$0")
            # Extrai versão direto do cabeçalho
            egrep '^#.*[0-9]{12}.*$' "$0" | tail -1 | cut -d : -f1 | tr -d \#
            exit 0
        ;;

        *)
            echo Opcao invalida: "$1"
            exit 1
        ;;

    esac
 
    shift

done

