package edu.unsam.food.repos

import edu.unsam.food.domain.Usuario
import edu.unsam.food.domain.LoginUsuario
import edu.unsam.food.domain.CondicionAlimenticia
import org.eclipse.xtend.lib.annotations.Accessors
import edu.unsam.food.domain.ExceptionID

class RepoUsuario extends Repositorio<Usuario> {
	
	static RepoUsuario instance
	
	static def RepoUsuario getInstance() {
		
		if (instance === null) {
			instance = new RepoUsuario
		}
		
		instance
	}
	

	def Usuario loginUser(LoginUsuario busqueda){
		lista.findFirst[usuario | usuario.loginCorrecto(busqueda)]
	}
	
	 def updateUser(Usuario usuario) {
		try {
			usuario.password = getById(usuario.id).password
			lista.remove(getById(usuario.id))
		} catch (Exception error) {
			throw new ExceptionID("ID inexistente.")
		}
		lista.add(usuario)
	}

	@Accessors
	CondicionAlimenticia condicionRecibida

}