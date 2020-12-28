package edu.unsam.food.repos
import edu.unsam.food.domain.Mensaje

class RepoMensajes extends Repositorio<Mensaje> {
	
	static RepoMensajes instance
	
	static def RepoMensajes getInstance() {
		
		if (instance === null) {
			instance = new RepoMensajes
		}
		
		instance
	}
	
	private new() {
	}	
	
	def entireDelete(int id){
		val dueñoMensaje = RepoMensajes.instance.getById(id).destinoMensaje
		dueñoMensaje.borrarMail(id)
		RepoMensajes.instance.deleteById(id)
	}
}