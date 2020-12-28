package edu.unsam.food.app

import edu.unsam.food.domain.UsuarioPorDefecto
import edu.unsam.food.repos.RepoUsuario


class BootstrapReact {
	
	val usuario = new UsuarioPorDefecto("Eduardo Biloni", "edu", 60, 1.70) => [password = "1234"]
	val usuario1 = 	new UsuarioPorDefecto("Alberto Sabatini","albertito86", 73, 1.76)
	val usuario2 = new UsuarioPorDefecto("Lucas Gimenez", "lucas", 80, 1.74)=>[password = "1234"]
	
	def void run() {
			crearUsuarios()
			usuario.enviarMensaje("Que ondaaaaa", usuario2)  //Se envía (y se crea) un mensaje a usuario2
			usuario2.enviarMensaje("Que ondaaaaa", usuario)
			usuario2.enviarMensaje("Contestame amigo", usuario)
			usuario1.enviarMensaje("Edu ponete las pilas loco", usuario)
	}
	
		def void crearUsuarios() {
		RepoUsuario.instance => [
			create(usuario)
			create(usuario1)
			create(usuario2)	
	]
	}
	
}