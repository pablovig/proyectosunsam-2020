package edu.unsam.food.repos

import edu.unsam.food.domain.Receta
import edu.unsam.food.domain.RecetaBusquedaAutor

class RepoRecetas extends Repositorio<Receta> {
	
	static RepoRecetas instance
	
	static def RepoRecetas getInstance() {
		
		if (instance === null) {
			instance = new RepoRecetas
		}
		
		instance
	}
	
	private new() {
	}
	
	def searchAutorYNombre(RecetaBusquedaAutor busqueda){
		lista.filter[receta | receta.busquedaAutor(busqueda)].toList
	}
	
	
}
