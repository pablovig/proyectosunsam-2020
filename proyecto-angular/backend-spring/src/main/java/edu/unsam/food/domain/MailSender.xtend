package edu.unsam.food.domain

import java.time.LocalDateTime

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
		]
		
		usuarioDestino.ingresarMensaje(mensaje)
	}
}