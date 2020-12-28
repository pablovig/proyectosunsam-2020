package edu.unsam.food.repos

import edu.unsam.food.domain.Alimento

class RepoAlimentos extends Repositorio<Alimento> {
	
	static RepoAlimentos instance
	
	static def RepoAlimentos getInstance() {
		
		if (instance === null) {
			instance = new RepoAlimentos
		}
		
		instance
	}
	
	
	
}