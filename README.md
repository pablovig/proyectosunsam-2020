
# Proyectos académicos 2020

En este repositorio se integran dos proyectos realizados en el segundo cuatrimestre de 2020 para la materia Algoritmos 3:

- `FoodOverflow` realizado en Angular (**proyecto angular**)
- `TeleFood` realizado en React.js + PrimeReact (**proyecto react**)

Ambos comparten la lógica de negocios en Xtend, la cual fue modelada en el primer cuatrimestre de 2020, a la que luego se le agregó la API Rest con SpringBoot y un repositorio en donde se alojan los datos.


### Foodoverflow

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

### TeleFood

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








# Primer ejemplo Servicio REST: Saludo con Springboot

## El proyecto

Antes que nada, la idea de este proyecto es que te sirva como base para poder desarrollar el backend en la materia [Algoritmos 3](https://algo3.uqbar-project.org/). Por eso está basado en _Maven_, y el archivo `pom.xml` tiene dependencias a

- Spring Boot
- JUnit 5
- la última versión actual de Xtend
- además de estar basado en la JDK 11

### Pasos para adaptar tu proyecto de Algo2 a Algo3

El proceso más simple para que puedan reutilizar el proyecto de Algo2 en Algo3 es:

- generar una copia de todo el directorio que contiene este proyecto
- eliminar la carpeta `.git` que está oculta
- renombrar en el `pom.xml` los valores para `artifactId`, `name` y `description` para que tengan el nombre de tu proyecto (renombrando gr-XX por el grupo correspondiente)

```xml
	<groupId>org.uqbar</groupId>
	<artifactId>---- nombre del proyecto ----</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<packaging>war</packaging>
	<name>---- nombre del proyecto ----</name>
	<description>---- acá va la description ----</description>
```

- copian del proyecto de Algo2 las carpetas `src/main/java` y `src/test/java` y la ubican en el mismo lugar en el proyecto de Algo3

El proyecto tiene un main, en la clase `RecetasApplication`, que levantará el servidor web en el puerto 8080. 
