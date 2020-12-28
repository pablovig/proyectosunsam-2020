package edu.unsam.food.controller

import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.CrossOrigin
import edu.unsam.food.repos.RepoUsuario
import org.springframework.http.ResponseEntity
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.DeserializationFeature
import edu.unsam.food.error.BusinessException
import org.springframework.web.bind.annotation.PostMapping
import edu.unsam.food.domain.Usuario
import edu.unsam.food.domain.LoginUsuario
import org.springframework.web.bind.annotation.GetMapping
import edu.unsam.food.domain.CondicionAlimenticia
import com.fasterxml.jackson.databind.SerializationFeature
import org.springframework.web.bind.annotation.PathVariable
import edu.unsam.food.repos.RepoMensajes
import edu.unsam.food.domain.Mensaje
import edu.unsam.food.domain.Busqueda
import org.springframework.web.bind.annotation.DeleteMapping


@RestController
@CrossOrigin
class MailController {
	
	
		@GetMapping("/mensajes/{id}")
		def mensajeByID(@PathVariable Integer id) {
			try {
				if (id === 0) {
					return ResponseEntity.badRequest.body('''Debe ingresar el id de Mensaje''')
				}

				val mensaje = RepoMensajes.instance.getById(id)
				
				if (mensaje === null) {
					return ResponseEntity.status(HttpStatus.NOT_FOUND).body('''No se encontro mensaje con ID <«id»>''')
				}
				ResponseEntity.ok(mensaje)
			} catch (RuntimeException e) {
				ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.message)
			}
		}
		
		@PostMapping("/mensajesdeusuario/{id}")
		def mensajesDeUnUsuario(@PathVariable Integer id, @RequestBody String body) {
			try {
				val busqueda = mapper.readValue(body, Busqueda)		

				val mensajes = RepoUsuario.instance.getById(id).bandejaDeEntrada
				
				val filtradoMensajes = mensajes.filter[mensaje | mensaje.coindiceBusqueda(busqueda.palabraBuscada)].toList
				
				ResponseEntity.ok(filtradoMensajes)
			} catch (RuntimeException e) {
				ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.message)
			}
		}
		
		
		
		@PutMapping("/mensajes/send/{usuarioEmisorID}/{usuarioDestinoID}")
		def sendMail(@RequestBody String body,
			@PathVariable Integer usuarioEmisorID,
			 @PathVariable Integer usuarioDestinoID
		) {
			try {
				val mensaje = mapper.readValue(body, Busqueda)

				if (usuarioDestinoID < 1 && usuarioEmisorID < 1) {
					return ResponseEntity.badRequest.body("Al menos uno de los usuarios no es valido")
				}
				
				val usuarioEmisor = RepoUsuario.instance.getById(usuarioEmisorID) // Se busca usuario Emisor
				val usuarioDestino = RepoUsuario.instance.getById(usuarioDestinoID) // Se busca usuario Destino
				usuarioEmisor.enviarMensaje(mensaje.palabraBuscada, usuarioDestino)
				
				ResponseEntity.ok("Se envía mail correctamente")
				
			} catch (BusinessException e) {
				ResponseEntity.badRequest.body(e.message)
			} catch (Exception e) {
				ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.message)
			}
		}
		
				@PutMapping("/cambiarleido/{id}")
		def cambiarleido(@PathVariable Integer id) {
			try {	

				val mensaje = RepoMensajes.instance.getById(id)
				
				mensaje.cambiarEstado()
				
				ResponseEntity.ok(mensaje)
			} catch (RuntimeException e) {
				ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.message)
			}
		}
		
	@DeleteMapping("/mensaje/{id}")
	def borrar(@PathVariable Integer id) {
		try {
			
			RepoMensajes.instance.entireDelete(id)

		} catch (BusinessException e) {
			ResponseEntity.badRequest.body(e.message)
		} catch (Exception e) {
			ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.message)
		}
	}
		
		
		static def mapper() {
			new ObjectMapper => [
				configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
				configure(SerializationFeature.INDENT_OUTPUT, true)
			]
		}
	}
		
		
//		@GetMapping("/mensajes/{mensajeID}/{usuarioID}")
//		def mensajeByIDUser(@PathVariable Integer mensajeID, @PathVariable Integer usuarioID) {
//			try {
//				if (mensajeID === 0 || usuarioID === 0) {
//					return ResponseEntity.badRequest.body('''Algun ID erroneo''')
//				}
//
//				val receta = RepoUsuario.instance.getById(id)
//				
//				if (receta === null) {
//					return ResponseEntity.status(HttpStatus.NOT_FOUND).body('''No se encontro receta con ID <«id»>''')
//				}
//				ResponseEntity.ok(receta)
//			} catch (RuntimeException e) {
//				ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.message)
//			}
//		} 
