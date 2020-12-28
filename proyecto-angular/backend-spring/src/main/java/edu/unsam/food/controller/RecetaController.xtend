package edu.unsam.food.controller

import org.springframework.web.bind.annotation.RestController
import org.springframework.http.ResponseEntity
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.SerializationFeature
import edu.unsam.food.repos.RepoRecetas
import edu.unsam.food.domain.RecetaBusquedaAutor
import edu.unsam.food.domain.Receta
import edu.unsam.food.error.BusinessException




@RestController
@CrossOrigin
class RecetaController {


	@PostMapping("/busqueda")
	def buscarPorNombre(@RequestBody String body) {
		try {
			
			val busqueda = mapper.readValue(body, String)
			val encontrada = RepoRecetas.instance.search(busqueda)				
			ResponseEntity.ok(encontrada)

		} catch (Exception e) {
			ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.message)
		}
	}
	
		@PostMapping("/busquedausuariologin")
	def buscarPorNombreYUsuarioLogueado(@RequestBody String body) {
		try {
			
			val busqueda = mapper.readValue(body, RecetaBusquedaAutor)
			val encontrada = RepoRecetas.instance.searchAutorYNombre(busqueda)				
			ResponseEntity.ok(encontrada)

		} catch (Exception e) {
			ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.message)
		}
	}
	
	@GetMapping("/busqueda")
	def buscarTodasRecetas() {
		try {
				val recetas = RepoRecetas.instance.lista
				ResponseEntity.ok(recetas)
			
		} catch (Exception e) {
			ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.message)
		}
	}
	
	@GetMapping("/receta/{id}")
def recetaByID(@PathVariable Integer id) {
	try {
		if (id === 0) {
			return ResponseEntity.badRequest.body('''Debe ingresar el id de Receta''')
		}

		val receta = RepoRecetas.instance.getById(id)
		
		if (receta === null) {
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body('''No se encontro receta con ID <«id»>''')
		}
		ResponseEntity.ok(receta)
	} catch (RuntimeException e) {
		ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.message)
	}
} 


	
	@PutMapping("/receta/{id}")
	def actualizar(@RequestBody String body, @PathVariable Integer id) {
		try {
			if (id === null || id === 0) {
				return ResponseEntity.badRequest.body("Debe ingresar el parámetro id")
			}
			val actualizada = mapper.readValue(body, Receta)

			if (id != actualizada.id) {
				return ResponseEntity.badRequest.body("ID de URL distinto que ID de Body")
			}
			if(!actualizada.esValida()){
				return ResponseEntity.badRequest.body("Receta no es valida")
			}
			RepoRecetas.instance.update(actualizada)
			ResponseEntity.ok(actualizada)
		} catch (BusinessException e) {
			ResponseEntity.badRequest.body(e.message)
		} catch (Exception e) {
			ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.message)
		}
	}
	
	@PutMapping("/recetanueva")
	def crear(@RequestBody String body) {
		try {
			val receta = mapper.readValue(body, Receta)
			if (receta.id != -1) {
				return ResponseEntity.badRequest.body("La receta no es nueva")
			}
			RepoRecetas.instance.create(receta)
			ResponseEntity.ok(receta)
		} catch (BusinessException e) {
			ResponseEntity.badRequest.body(e.message)
		} catch (Exception e) {
			ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.message)
		}
	}
	
	@DeleteMapping("/receta/{id}")
	def borrar(@PathVariable Integer id) {
		try {
			RepoRecetas.instance.deleteById(id)

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


