
# Proyectos académicos 2020

En este repositorio se integran dos proyectos realizados en el segundo cuatrimestre de 2020 para la materia Algoritmos 3:

- `FoodOverflow` realizado en Angular (**proyecto angular**)
- `TeleFood` realizado en React.js + PrimeReact (**proyecto react**)

Ambos comparten la lógica de negocios en Xtend, la cual fue modelada en el primer cuatrimestre de 2020, a la que luego se le agregó la API Rest con SpringBoot y un repositorio en donde se alojan los datos.



Los proyectos fueron realizados por **Pablo Vigliero** (Yo) y **Santiago Ranieri**.



## Foodoverflow

Esta aplicación mostrará un menú de recetas, en donde inicialmente se pedirá un logueo de usuario. Es responsive para `PC`, `Tablet` y `Teléfono móvil`.

_Recordar bajar los módulos poniendo **npm install** en consola, dentro de la carpeta del proyecto_

![loginAngular](https://github.com/pablovig/proyectosunsam-2020/raw/master/imagenes%20README/foodoverflow/login.JPG)

Una vez ingresado se podrán visualizar las recetas disponibles, en donde también se podrán filtrar por usuario Autor o nombre de receta.

![homeAngular](https://github.com/pablovig/proyectosunsam-2020/raw/master/imagenes%20README/foodoverflow/home.JPG)

Luego podremos visualizar sus ingredientes y pasos de preparación, y de ser autor, también se podrá editar la misma.

![recetavistaAngular](https://github.com/pablovig/proyectosunsam-2020/raw/master/imagenes%20README/foodoverflow/recetavista.JPG)

También hay un Perfil de usuario en donde se detallan sus datos, condiciones y preferencias, los cuales se tendrán en cuenta a la hora de filtrar las recetas.

![perfilAngular](https://github.com/pablovig/proyectosunsam-2020/raw/master/imagenes%20README/foodoverflow/perfil.JPG)

EL menú para agregar ingredientes y alimentos preferidos o No preferidos será de la siguiente manera.

![alimentosAngular](https://github.com/pablovig/proyectosunsam-2020/raw/master/imagenes%20README/foodoverflow/alimentos.JPG)



## TeleFood

Esta es más simple que la anterior la cual funciona como una aplicación de mensajería. Debido al poco tiempo que se disponía fue diseñada sólo para el tamaño de un `Teléfono móvil`.

_Recordar bajar los módulos poniendo **yarn** en consola, dentro de la carpeta del proyecto_

Al inicio se pide un login de usuario.

![loginReact](https://github.com/pablovig/proyectosunsam-2020/blob/master/imagenes%20README/telefood/login.JPG)

Luego se mostrará nuestra bandeja de entrada indicando los mensajes vistos y no vistos con posiblidad de cambiar estos estados, y también con opción de eliminarlos.

![bandejaReact](https://github.com/pablovig/proyectosunsam-2020/blob/master/imagenes%20README/telefood/bandeja.JPG)

Al hacer doble click en alguno de ellos se mostrará el contenido del mensaje, usuario Emisor y hora de envío. También.

![lecturaReact](https://github.com/pablovig/proyectosunsam-2020/blob/master/imagenes%20README/telefood/lectura.JPG)

También tenemos la posibilidad de enviar un mensaje desde el menú desplegable superior derecho, en donde nos deriva a una nueva pantalla con nuestros 
contactos.

![menuReact](https://github.com/pablovig/proyectosunsam-2020/blob/master/imagenes%20README/telefood/menudesplegable.JPG)

Al seleccionar en cualquiera de ellos nos dirige a lo que será la escritura de nuestro mensaje a enviar.

![escrituraReact](https://github.com/pablovig/proyectosunsam-2020/blob/master/imagenes%20README/telefood/escritura.JPG)
