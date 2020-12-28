package edu.unsam.food.domain

import java.time.LocalDateTime
import edu.unsam.food.repos.RepoMensajes
import java.time.LocalDate

class MailSender {
	
	static MailSender instance
	
	static def getInstance() {
		
		if (instance === null) {
			instance = new MailSender
		}
		
		instance
	}
	
	def void enviarMensaje(String mensajeAEnviar, Usuario usuarioDestino, Usuario usuarioEmisor){
		
		var mensaje = new Mensaje(mensajeAEnviar, usuarioDestino) => [
			
			cuerpoDeMensaje = mensajeAEnviar
			destinatario = usuarioDestino.nombreYApellido
			emisor = usuarioEmisor.nombreYApellido
			horaDeEmision = LocalDateTime.now()
			destinoMensaje = usuarioDestino
		]
		
		RepoMensajes.instance.create(mensaje)
		
		usuarioDestino.ingresarMensaje(mensaje)
	}
}