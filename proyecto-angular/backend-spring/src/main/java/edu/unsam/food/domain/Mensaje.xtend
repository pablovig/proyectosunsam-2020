package edu.unsam.food.domain
import java.time.LocalDateTime
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Mensaje {
	
	String cuerpoDeMensaje
	String destinatario
	String emisor
	LocalDateTime horaDeEmision
	LocalDateTime horaDeLectura
	boolean mensajeLeido = false
	
	new(){}
	
	new (String _cuerpoDeMensaje, Usuario _destinatario){
	
		cuerpoDeMensaje = _cuerpoDeMensaje
		destinatario = _destinatario.nombreYApellido
	}
	
	def String verMensaje(){
		
		mensajeLeido = true
		horaDeLectura = LocalDateTime.now()
		return cuerpoDeMensaje
		//return (horaDeEmision + " " + emisor + " " + cuerpoDeMensaje)
	}
}