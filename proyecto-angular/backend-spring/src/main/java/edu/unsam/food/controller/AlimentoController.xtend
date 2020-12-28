package edu.unsam.food.controller

import edu.unsam.food.repos.RepoAlimentos
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController
import org.springframework.http.HttpStatus

@RestController
@CrossOrigin
class AlimentoController{
	
	@GetMapping("/alimento")
	def mostrarAlimento() {
		try {
			val alimento = RepoAlimentos.instance.lista
			ResponseEntity.ok(alimento)
		} catch (Exception e) {
			ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.message)
		}
	}
 

	}
	