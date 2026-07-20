# main
1. Application de README.md
- Démarrer le backend  : $ java -jar build/libs/microcrm-0.0.1-SNAPSHOT.jar
- Démarrer le frontend : $ npx @angular/cli serve
- http: http://localhost:4200/  
Image  
![main_page_acceuil.png](misc/screenshots/main_page_acceuil.png)


# dev1 
1. Analyse du fichier Dockerfile :
   - Trois images : 
    orion-microcrm-front : Linux Debian 12, Node.js version 22, Caddy + ressource Angular html
    orion-microcrm-back  : Linux Ubuntu 22.04, Gradle 8.7, Java + ressource Spring-boot app.jar
    orion-microcrm-standalone : images de front et back + supervisor
    Conclusion : Il y a des erreurs ( EXPOSE 4200 pour le back) 
  
   
2. Refonte du fichier Dockerfile : 
   - Remplacer les distibutions Linux
   - Remplacer Caddy par Nginx

   - $ docker build --target front -t microcrm-front .
   - $ docker run -it --rm -p 80:80 microcrm-front:latest
   
   - docker build --target back -t microcrm-back:latest .
   - docker run -it --rm -p 8080:8080 microcrm-back:latest  

    ![front_back_containers.png](misc/screenshots/front_back_containers.png)

   - docker build --target standalone -t microcrm-standalone:latest .
   - docker run -it --rm -p 8080:8080 -p 80:80  microcrm-standalone:latest  
   ![standalone_docker_container.png](misc/screenshots/standalone_docker_container.png)  
   
 
   