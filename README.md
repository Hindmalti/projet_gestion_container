# Introduction

Ceci est un outil simple de gestion de conteneurs (Comme Docker). Il permet de créer et gérer des conteneurs tout en personnalisant leur configuration. 

Il est possible de créer une image, lui attribuer un nom, choisir sa taille et son emplacement.

À partir de cette dernière, vous pourrez créer un conteneur : choisir son nom, l'image sur laquelle il reposera, son chemin, ses bridges, les adresses IPV4 associées ainsi que le programme qui sera exécuté dessus.

De plus, vous avez la possibilité de créer un bridge, lui attribuer un nom et lui associer une adresse IPV4.

> Pour connaître toutes les commandes possibles, un utilitaire help est mis à votre disposition grâce à la commande : `baleine.sh help`

# Structure du code

Les scripts shell de ce projet sont structurés comme suit : 

Image | Bridge | Container
------------ | -------------| -------------
create_image | create_bridge| create_container
list_images  | list_bridges | list_containers
remove_images  | remove_bridges | remove_containers
 | |  up_bridge| stop_container
  | | down_bridge | exec_container

## Images

* create_image : permet de créer une image
```             
baleine.sh image create -i myimage -s 10240 -r /var/lib/baleine/images -p http_proxy=http://proxy.polytech-lille.fr:3128
```

* list_image : permet de lister les images existantes 
```
baleine.sh image list 
```

* remove_images : permet la suppression de l'image donnée en argument. 

```
baleine.sh image remove -i myimage 
```

## Bridges 

* create_bridge : permet de créer un bridge
```
baleine.sh bridge create -b mybridge -a 192.168.42.1/24
```

* list_bridge : permet de lister les bridges existante
```
baleine.sh bridge list 
```

* remove_bridges : permet la suppression de du bridge donné en argument
```
baleine.sh bridge remove -b mybridge 
```

* up_bridge : permet de rendre fonctionnel un bridge.
```bash
baleine.sh bridge up -b mybridge 
```

* down_bridge : permet de désactiver un bridge
```bash
baleine.sh bridge down -b mybridge 
```

## Containers

* create_container : permet de créer un containe 
```
baleine.sh container create -c mycontainer -i myimage -b mybridge -r /var/lib/baleine/containers -a 192.168.42.1/24 -p "/usr/sbin/apache2ctl start"
```

* list_container : permet de lister les containers existante
```
baleine.sh container list 
```

* remove_containers : permet la suppression de du container donné en argument
```
baleine.sh container remove -c mycontainer 
```

* stop_container :
```bash
baleine.sh container stop -c mycontainer 
```

* exec_container :
```bash
baleine.sh container exec -c mycontainer 
```