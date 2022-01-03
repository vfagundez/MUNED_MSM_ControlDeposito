# ControlDeposito

Proyecto Final de la asignatura Métodos de Simulación y Modelado de modelado de un deposito cilíndrico con dos válvulas de control en modélica


## Comenzando 🚀

Para poder utilizar este script es necesario tener instalado un entorno que 
permita la ejecución de lenguaje Modelica como puede ser
[OpenModelica](https://www.openmodelica.org/).


### Instalación y Configuración 🔧

Una vez descargado el proyecto encontramos la siguiente estructura de carpetas
```
.
├── etc
├── img
├── logs
├── src
└── readme.md
```
* en la carpeta _etc_ encontraremos los archivos de configuración
* en la carpeta _img_ encontraremos las imagenes para esta  documentación
* en la carpeta de _logs_ encontraremos todos los archivos de registro de
la aplicación
* en la carpeta _src_ encontramos el codigo fuente de la aplicación

## Enunciado 📄

Consideremos el sistema mostrado en la figura, que está compuesto por un depósito 
cilíndrico, una tubería a través de la cual entra un caudal de líquido Fin al 
depósito, y dos tuberías de desagüe con sendas válvulas, a través de las cuales 
sale del depósito un caudal de líquido Fout,1 y Fout,2 respectivamente. El área 
de la base del depósito, A, es igual a 2 m2.

![Esquema del sistema de deposito y valvulas](/img/esquemaDeposito.png?raw=true "Esquema del sistema de deposito y  valvulas")

Una válvula puede encontrarse en dos fases: abierta (av = 1) y cerrada (av = 0).
En el primer caso (abierta) permite el paso de líquido y en el segundo (cerrada)
lo impide. La fase de la primera válvula cambia cada T = 30 segundos, estando 
inicialmente cerrada.Mientras la primera válvula está abierta, la segunda válvula 
está cerrada y viceversa. 
La primera tubería está situada a una altura h1 = 4 m y la segunda a una altura 
h2 = 1.5 m. Sólo circula líquido por una tubería si, estando su válvula abierta, 
la altura del líquido en el depósito (h) es mayor que la altura a la que está 
situada la tubería. Cuando circula líquido a través de las tuberías, el caudal se 
calcula de la forma siguiente:

![Ecuaciones Flujo Masico Salida](/img/ecuacionesFlujoMasico.png?raw=true "Ecuaciones Flujo Masico Salida")

siendo K un parámetro de valor conocido. El valor de K es 0.5, expresado en unidades del sistema internacional.
El caudal de entrada de líquido, Fin, es proporcionado por una bomba que es 
manipulada por un controlador PI. El caudal de la bomba (Fin) es proporcional a 
la tensión de control de la bomba (u) en el rango de valores entre 0 y 20 
voltios. La relación constitutiva de la bomba es la siguiente:
![ecuacionesFlujoMasicoEntrante](/img/ecuacionesFlujoMasicoEntrada.png?raw=true "ecuacionesFlujoMasicoEntrante")

## Funcionamiento ⚙️

_Explica como ejecutar el sistema_


## Autores ✒️


* **Victor Fagúndez Poyo** - *Trabajo Inicial* - [vincitori-dev](https://github.com/vincitori-dev)



