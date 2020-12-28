package edu.unsam.food.domain

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class Entidad {
	
	 Integer id
	
	def boolean busqueda(String value)
	
}