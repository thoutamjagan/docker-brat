FROM httpd


RUN apt-get clean && apt-get update && apt-get install -y locales
# Set the locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 
ENV BRAT_VERSION Gengo-LZ-v1.3.1
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && apt-get update --fix-missing && \
    apt-get update && apt-get install -qq -y --no-install-recommends wget ca-certificates && \
    #rm -rf /var/lib/apt/lists/* && \
    wget -qO /usr/local/apache2/htdocs/$BRAT_VERSION.tar.gz "http://weaver.nlplab.org/~brat/releases/brat-v1.3_Crunchy_Frog.tar.gz" && \
    tar -xvzf /usr/local/apache2/htdocs/$BRAT_VERSION.tar.gz && \
    mv /usr/local/apache2/brat-v1.3_Crunchy_Frog/ /usr/local/apache2/htdocs/ && \
    rm /usr/local/apache2/htdocs/$BRAT_VERSION.tar.gz 

RUN apt-get install -y python3 

RUN apt-get update -y

RUN apt-get install -y python3-pip

RUN pip3 install --upgrade pip

RUN apt-get install git -y

RUN pip3 install git+git://github.com/vitalco/simstring-python-package#egg=simstring && \
    apt-get purge -y --auto-remove wget 


ARG username=jag
ARG password=Password
ARG admin_email=jaganthoutam@gmail.com

ADD httpd.conf /usr/local/apache2/conf/
ADD install.sh /usr/local/apache2/htdocs/brat-v1.3_Crunchy_Frog/

RUN /usr/local/apache2/htdocs/brat-v1.3_Crunchy_Frog/install.sh $username $password $admin_email

RUN wget -qO /usr/local/apache2/htdocs/flup-1.0.2.tar.gz "https://www.saddi.com/software/flup/dist/flup-1.0.2.tar.gz"
RUN tar -xvzf /usr/local/apache2/htdocs/flup-1.0.2.tar.gz -C /usr/local/apache2/htdocs/brat-v1.3_Crunchy_Frog/server/lib/

