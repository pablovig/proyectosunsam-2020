package edu.unsam.food.domain
import java.time.LocalDateTime
import org.eclipse.xtend.lib.annotations.Accessors
import com.fasterxml.jackson.annotation.JsonIgnore
import java.time.format.DateTimeFormatter
import com.fasterxml.jackson.annotation.JsonProperty
import com.fasterxml.jackson.annotation.JsonFormat
import java.time.LocalDate

@Accessors
class Mensaje extends Entidad{
	
	String cuerpoDeMensaje
	String destinatario
	String emisor
	@JsonIgnore LocalDateTime horaDeEmision
	@JsonIgnore LocalDateTime horaDeLectura
	@JsonIgnore Usuario destinoMensaje
	boolean mensajeLeido = false
	//static String DATE_PATTERN = "yyyy-MM-dd"
	
	new(){}
	
	new (String _cuerpoDeMensaje, Usuario _destinatario){
	
		cuerpoDeMensaje = _cuerpoDeMensaje
		destinatario = _destinatario.nombreYApellido
	}
	
	def String verMensaje(){
		
		mensajeLeido = true
		horaDeLectura = LocalDateTime.now()
		return cuerpoDeMensaje
	}
	
	def cambiarEstado(){
		mensajeLeido? mensajeLeido = false : mensajeLeido = true
	}
		
	override boolean busqueda(String value){
		return id == value
	}

	@JsonProperty("fechaDeEmision")
	def String getHoraDeEmision(){
		return horaDeEmision.dayOfMonth + "/" + horaDeEmision.monthValue + "/" + horaDeEmision.year
	}
	
	def boolean coindiceBusqueda(String palabraBusqueda){
		cuerpoDeMensaje.toLowerCase().contains(palabraBusqueda.toLowerCase()) || emisor.toLowerCase().contains(palabraBusqueda.toLowerCase())
	}

}