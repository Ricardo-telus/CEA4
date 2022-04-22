##Assignment 4, maquinas virtuales GCP
#comando para la creacion de la maquina 1
gcloud compute instances create app1 \
    --image-family debian-9 \
    --image-project debian-cloud \
    --tags webapp \
    --metadata startup-script="#! /bin/bash
        sudo apt-get update
        sudo apt-get install apache2 -y
        sudo service apache2 restart
        echo '<!DOCTYPE html>
            <html lang='en'>
            <head>
                <meta charset='UTF-8'>
                <meta http-equiv='X-UA-Compatible' content='IE=edge'>
                <meta name='viewport' content='width=device-width, initial-scale=1.0'>
                <title>Assignment 4</title>
            </head>
            <body>
                <h1>App1</h1>
            </body>
            </html>' | tee 
            /var/www/html/index.html
    "

#comando para la creacion de la maquina 2
gcloud compute instances create app2 \
    --image-family debian-9 \
    --image-project debian-cloud \
    --tags webapp \
    --metadata startup-script="#! /bin/bash
        sudo apt-get update
        sudo apt-get install apache2 -y
        sudo service apache2 restart
       echo '<!DOCTYPE html>
            <html lang='en'>
            <head>
                <meta charset='UTF-8'>
                <meta http-equiv='X-UA-Compatible' content='IE=edge'>
                <meta name='viewport' content='width=device-width, initial-scale=1.0'>
                <title>Assignment 4</title>
            </head>
            <body>
                <h1>App2</h1>
            </body>
            </html>' | tee 
            /var/www/html/index.html
    "

#comando para la creacion de la maquina 3
gcloud compute instances create app3 \
    --image-family debian-9 \
    --image-project debian-cloud \
    --tags webapp \
    --metadata startup-script="#! /bin/bash
        sudo apt-get update
        sudo apt-get install apache2 -y
        sudo service apache2 restart
        echo '<!DOCTYPE html>
            <html lang='en'>
            <head>
                <meta charset='UTF-8'>
                <meta http-equiv='X-UA-Compatible' content='IE=edge'>
                <meta name='viewport' content='width=device-width, initial-scale=1.0'>
                <title>Assignment 4</title>
            </head>
            <body>
                <h1>App3</h1>
            </body>
            </html>' | tee 
            /var/www/html/index.html
    "
#Comprobacion para ver si fueron creada:
gcloud compute instances list

#comando configurar una regle de INGREES en el firewall para todas por el tag hacia el puerto 80
gcloud compute firewall-rules create www-firewall-network-lb \
    --target-tags webapp \
    --allow tcp:80

#Configuraciones de la red,  praticamente load balancer
#comando para crear el balanceador uno de google
gcloud compute addresses create loadbalancer-1

#comando para la creacion de un archivo healt-check el cual comprobara el estado de las maquinas
gcloud compute http-health-checks create hc1

#comando para crear un target pool en conjunto con el health-check 
gcloud compute target-pools create www-pool \
    --http-health-check hc1

#comando para agregar todas las instancias o VM al target pool
gcloud compute target-pools add-instances www-pool \
    --instances app1,app2,app3

#comando para agregar una regla de entraada o acceso al balanceador, la cual hace que sea visible para todos
gcloud compute forwarding-rules create www-rule \
    --ports 80 \
    --address loadbalancer-1 \
    --target-pool www-pool

# comando para verificar si la regla ha sido creada exitosamente
gcloud compute forwarding-rules describe www-rule