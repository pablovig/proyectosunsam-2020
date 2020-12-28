package edu.unsam.food.domain

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Busqueda {
	String palabraBuscada
	
	new(){}
	
    new(String _palabra ){ 
    	palabraBuscada = _palabra
    }
}