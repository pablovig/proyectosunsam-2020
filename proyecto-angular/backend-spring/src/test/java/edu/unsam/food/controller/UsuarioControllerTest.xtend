package edu.unsam.food.controller

import org.springframework.boot.test.autoconfigure.json.AutoConfigureJsonTesters
import org.springframework.test.context.ContextConfiguration
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest
import org.junit.jupiter.api.DisplayName
import edu.unsam.food.controller.UsuarioController
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.test.web.servlet.MockMvc
import edu.unsam.food.repos.RepoUsuario
import org.junit.jupiter.api.BeforeEach
import java.time.LocalDate
import org.junit.jupiter.api.Test
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.SerializationFeature
import static org.junit.jupiter.api.Assertions.assertEquals
import static org.junit.jupiter.api.Assertions.assertTrue
import org.springframework.test.annotation.DirtiesContext
import edu.unsam.food.domain.UsuarioPorDefecto
import edu.unsam.food.domain.Alimento
import edu.unsam.food.domain.GrupoAlimenticio
import edu.unsam.food.domain.Diabetico
import edu.unsam.food.domain.Celiaco
import edu.unsam.food.domain.Mensaje
import edu.unsam.food.domain.Usuario
import org.junit.jupiter.api.AfterEach
import edu.unsam.food.domain.LoginUsuario
import edu.unsam.food.domain.UsuarioAutor

@AutoConfigureJsonTesters
@ContextConfiguration(classes=UsuarioController)
@WebMvcTest
@DirtiesContext
@DisplayName("Dado un controller de usuarios")
class UsuarioControllerTest {
	
	@Autowired
	MockMvc mockMvc
	RepoUsuario repoUsuario = RepoUsuario.instance
	UsuarioAutor usuarioLogueado
	UsuarioPorDefecto usuarioDestino
	UsuarioAutor usuarioBody	
	
	@BeforeEach
	def void init() {
		repoUsuario.lista.clear
		usuarioLogueado = new UsuarioAutor(new UsuarioPorDefecto(
			"Pedro Alvarez", "peal14", 80, 1.80
			) => [
				password = "1234"
				agregarAlimentoPreferido(new Alimento("Peceto", GrupoAlimenticio.CARNES_PESCADO_HUEVO))
				fechaDeNacimiento = LocalDate.now()
				agregarCondicionAlimenticia(new Diabetico())
				agregarCondicionAlimenticia(new Celiaco())
				ingresarMensaje(new Mensaje => [
					cuerpoDeMensaje = "Hola como estas"
					destinatario = "Pedro Alvarez"
	
				])
			])
				
		usuarioDestino = new UsuarioPorDefecto("Manuel Gerry", "manuguer", 60, 1.50)
		
		repoUsuario => [
			create(usuarioDestino)
			create(usuarioLogueado)
		]
	}
	
	@AfterEach
	def void end(){
		repoUsuario.lista.clear
		repoUsuario.idRepo = 1
	}
	
	
	
	@DisplayName("Se obtiene el usuario logueado")
	@Test
	def void testGetUsuarioLogueado() {
		
		val responseEntity = mockMvc.perform(
			MockMvcRequestBuilders.post("/perfil").content("2")
		).andReturn.response
		
		val usuario = responseEntity.contentAsString.fromJson(Usuario)
		
		assertEquals(200, responseEntity.status)
		assertEquals("Pedro Alvarez",usuario.nombreYApellido)
	}
	
	@DisplayName("Se recibe un id de usuario incorrecto y se devuelve mensaje de error")
	@Test
	def void testGetIdUsuarioIncorrecto() {
		
		val responseEntity = mockMvc.perform(
			MockMvcRequestBuilders.post("/perfil").content("10")
		).andReturn.response
		
		assertEquals(400, responseEntity.status)
		assertEquals("Solicitud Incorrecta", responseEntity.contentAsString)
	}
	
	@DisplayName("Se realiza un login correcto")
	@Test
	def void testLoginCorrecto() {
		val loginUsuario = new LoginUsuario() => [ username = "peal14" password = "1234"]
		val responseEntity = mockMvc.perform(
			MockMvcRequestBuilders.post("/login").content(mapper.writeValueAsString(loginUsuario))
		).andReturn.response
		
		assertEquals(200, responseEntity.status)
	}
	
	@DisplayName("Se realiza un login incorrecto y devuelve error")
	@Test
	def void testLoginIncorrecto() {
		val loginUsuario = new LoginUsuario() => [ username = "peal14" password = "123456"]
		val responseEntity = mockMvc.perform(
			MockMvcRequestBuilders.post("/login").content(mapper.writeValueAsString(loginUsuario))
		).andReturn.response
		
		assertEquals(401, responseEntity.status)
		assertEquals("Usuario o contraseña invalido", responseEntity.contentAsString)
	}
	
	@DisplayName("Se actualiza un usuario y el estado es válido")
	@Test
	def void testPutUsuarioActualizado() {
		
		usuarioBody = new UsuarioAutor(new UsuarioPorDefecto(
			"Pedro Alberto Alvarez", "pedrito22", 90, 1.80
			) => [
				id = usuarioLogueado.id
				agregarAlimentoPreferido(new Alimento("Peceto", GrupoAlimenticio.CARNES_PESCADO_HUEVO))
				agregarCondicionAlimenticia(new Diabetico())
				agregarCondicionAlimenticia(new Celiaco())
				fechaDeNacimiento = "2020-10-23"
				ingresarMensaje(new Mensaje => [
					cuerpoDeMensaje = "Hola como estas"
					emisor = RepoUsuario.instance.getById(1).nombreYApellido
					destinatario = "Pedro Alberto Alvarez"
				])
			])
		
		
		val responseEntityPut = mockMvc.perform(
			MockMvcRequestBuilders.put("/perfil").content(mapper.writeValueAsString(usuarioBody))).andReturn.response
		
		val responseEntityGet = mockMvc.perform(
			MockMvcRequestBuilders.post("/perfil").content("2")).andReturn.response
		
		val usuarioActualizado = responseEntityGet.contentAsString.fromJson(Usuario)
		
		assertEquals(200, responseEntityPut.status)
		assertEquals(usuarioActualizado.nombreYApellido, usuarioBody.nombreYApellido)
		
	}
	
	@DisplayName("Se intenta actualizar un usuario con id incorrecto y tirra mensaje de error")
	@Test
	def void testPutUsuarioActualizadoConIdIncorrecto() {
		
		usuarioBody = new UsuarioAutor(new UsuarioPorDefecto(
			"Pedro Alberto Alvarez", "pedrito22", 90, 1.80
			) => [
				id = 7
				agregarAlimentoPreferido(new Alimento("Peceto", GrupoAlimenticio.CARNES_PESCADO_HUEVO))
				agregarCondicionAlimenticia(new Diabetico())
				agregarCondicionAlimenticia(new Celiaco())
				ingresarMensaje(new Mensaje => [
					cuerpoDeMensaje = "Hola como estas"
					emisor = RepoUsuario.instance.getById(1).nombreYApellido
					destinatario = "Pedro Alberto Alvarez"
				])
			])
		
		val responseEntityPut = mockMvc.perform(
			MockMvcRequestBuilders.put("/perfil").content(mapper.writeValueAsString(usuarioBody))
		).andReturn.response
		
		assertEquals(400, responseEntityPut.status)
		assertEquals("Solicitud Incorrecta", responseEntityPut.contentAsString)

	}
	
	@DisplayName("Se intenta actualizar un usuario con peso no valido y tirra mensaje de error")
	@Test
	def void testPutUsuarioActualizadoConAtributoInvalido() {
		
		usuarioBody = new UsuarioAutor(new UsuarioPorDefecto(
			"Pedro Alberto Alvarez", "pedrito22", 90, 1.80
			) => [
				id = usuarioLogueado.id
				agregarAlimentoPreferido(new Alimento("Peceto", GrupoAlimenticio.CARNES_PESCADO_HUEVO))
				agregarCondicionAlimenticia(new Diabetico())
				peso = 0.0
				ingresarMensaje(new Mensaje => [
					cuerpoDeMensaje = "Hola como estas"
					emisor = RepoUsuario.instance.getById(1).nombreYApellido
					destinatario = "Pedro Alberto Alvarez"
				])
			])
		
		val responseEntityPut = mockMvc.perform(
			MockMvcRequestBuilders.put("/perfil").content(mapper.writeValueAsString(usuarioBody))
		).andReturn.response
		
		assertEquals(400, responseEntityPut.status)
		assertEquals("Atributos de usuario no validos", responseEntityPut.contentAsString)

	}
	
	static def <T extends Object> fromJson(String json, Class<T> expectedType) {
		mapper.readValue(json, expectedType)
	}

	static def mapper() {
		new ObjectMapper => [
			configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
			configure(SerializationFeature.INDENT_OUTPUT, true)
		]
	}
	
}