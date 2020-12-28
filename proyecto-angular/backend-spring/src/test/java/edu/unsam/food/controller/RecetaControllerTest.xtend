package edu.unsam.food.controller

import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.SerializationFeature
import java.util.List
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.json.AutoConfigureJsonTesters
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest
import org.springframework.test.context.ContextConfiguration
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders
import static org.junit.jupiter.api.Assertions.assertEquals
import static org.junit.jupiter.api.Assertions.assertTrue
import edu.unsam.food.repos.RepoRecetas
import edu.unsam.food.domain.Receta
import edu.unsam.food.domain.UsuarioAutor
import edu.unsam.food.domain.UsuarioPorDefecto
import edu.unsam.food.domain.RecetaSimple
import edu.unsam.food.domain.RecetaCompuesta
import org.junit.jupiter.api.AfterEach

@AutoConfigureJsonTesters
@ContextConfiguration(classes=RecetaController)
@WebMvcTest
@DisplayName("Testeo de un RecetaController")
class RecetaControllerTest {
	
	@Autowired
	MockMvc mockMvc
	RepoRecetas repoRecetas = RepoRecetas.instance
	Receta receta
	UsuarioAutor usuario
	
	@BeforeEach
	def void init() {
		repoRecetas.lista.clear
		usuario = new UsuarioAutor(new UsuarioPorDefecto("Demian","demi14", 1.80, 80))
		repoRecetas.create(new RecetaSimple("Milanesa", usuario))
		repoRecetas.create(new RecetaCompuesta("Milanesa con Papas Fritas y Huevo Frito", new UsuarioAutor(new UsuarioPorDefecto("Lucas Gimenez", "Gimi14", 80, 1.74))))
		receta = repoRecetas.create(new RecetaSimple("Guiso", usuario))
	}
	
	@AfterEach
	def void end(){
		repoRecetas.lista.clear
		repoRecetas.idRepo = 1
	}

	@DisplayName("Al iniciar Home obtenemos todas las recetas.")
	@Test
	def void testGetAllRecetas() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/busqueda")).andReturn.response
		val recetas = responseEntity.contentAsString.fromJsonToList(Receta)
		assertEquals(200, responseEntity.status)
		assertEquals(recetas.size, 3)
	}
	
	@DisplayName("Buscamos colocando inicio de palabra Milanesa y obtenemos receta con ese nombre de Receta")
	@Test
	def void testBuscaRecetaPorNombreReceta() {
		val nombreReceta = "mil"
		val responseEntity = mockMvc.perform(
			MockMvcRequestBuilders.post("/busqueda").content(mapper.writeValueAsString(nombreReceta))).andReturn.
			response
		val recetas = responseEntity.contentAsString.fromJsonToList(Receta)
		assertEquals(200, responseEntity.status)
		assertTrue(recetas.exists[receta | receta.getNombreDelPlato.toLowerCase.contains(nombreReceta)])
		assertEquals(recetas.size,2)
	}
	
	@DisplayName("Buscamos colocando inicio de nombre Demian y obtenemos receta con ese Autor")
	@Test
	def void testBuscaRecetaPorNombreAutor() {
		val nombreAutor = "dem"
		val responseEntity = mockMvc.perform(
			MockMvcRequestBuilders.get("/busqueda").content(mapper.writeValueAsString(nombreAutor))).andReturn.
			response
		val recetas = responseEntity.contentAsString.fromJsonToList(Receta)
		assertEquals(200, responseEntity.status)
		assertTrue(recetas.exists[receta | receta.autor.nombreYApellido.toLowerCase.contains(nombreAutor)])
	}
	
	@DisplayName("Se busca receta por el ID y obtengo la receta")
	@Test
	def void testBuscaRecetaPorIdCorrecto() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/receta/1")).andReturn.response
		val recetaBuscada = responseEntity.contentAsString.fromJson(Receta)
		assertEquals(200, responseEntity.status)
		assertEquals(recetaBuscada.nombreDelPlato, "Milanesa")
	}
	
	@DisplayName("Se busca una palabra y no obtenemos resultados")
	@Test
	def void testBuscarRecetaNoEncontrada() {
		val nombreReceta = "Pizza"
		val responseEntity = mockMvc.perform(
			MockMvcRequestBuilders.post("/busqueda").content(mapper.writeValueAsString(nombreReceta))).andReturn.
			response
		val recetas = responseEntity.contentAsString.fromJsonToList(Receta)
		assertEquals(200, responseEntity.status)
		assertTrue(recetas.isEmpty)
	}
	
	

	@DisplayName("Se busca receta por id CERO (Nulo) y obtengo error 400")
	@Test
	def void testBuscaRecetaPorIdInvalido() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/receta/0")).andReturn.response
		assertEquals(400, responseEntity.status)
		assertEquals("Debe ingresar el id de Receta", responseEntity.contentAsString)
	}
	
	@DisplayName("Se busca receta por ID que no existe y obtengo error 404")
	@Test
	def void testBuscaRecetaPorIdInexistente() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/receta/100")).andReturn.response
		assertEquals(404, responseEntity.status)
		assertEquals("No se encontro receta con ID <100>", responseEntity.contentAsString)
	}
	
	@DisplayName("Se actualiza una receta con values validos")
	@Test
	def void testActualizarRecetaValida() {
		val recetaBody = getReceta() =>[ id = receta.id ]

		val responseEntityPut = mockMvc.perform(
			MockMvcRequestBuilders.put("/receta/" + receta.id).content(mapper.writeValueAsString(recetaBody))).andReturn.
			response
		assertEquals(200, responseEntityPut.status)
		
		val responseEntityGet = mockMvc.perform(MockMvcRequestBuilders.get("/receta/" + receta.id)).andReturn.response
		val recetaActualizada = responseEntityGet.contentAsString.fromJson(Receta)
		assertEquals(200, responseEntityGet.status)
		assertEquals(recetaActualizada.getNombreDelPlato, recetaBody.getNombreDelPlato)
	}
	
	@DisplayName("Se intenta actualizar receta pero no coincide ID de la url y el body y produce error 400")
	@Test
	def void testActualizaRecetaDistintosIds() {
		val recetaBody = getReceta => [id = receta.id]
		
		val responseEntityPut = mockMvc.perform(
			MockMvcRequestBuilders.put("/receta/" + (receta.id + 100)).content(mapper.writeValueAsString(recetaBody))).
			andReturn.response
		assertEquals(400, responseEntityPut.status)
		assertEquals("ID de URL distinto que ID de Body", responseEntityPut.contentAsString)
	}
	
	@DisplayName("Se crea nueva receta pero el ID no es -1 por lo que arroja error 500")
	@Test
	def void testCrearRecetaDistintoID() {
		val recetaBody = getReceta() 

		val responseEntityPut = mockMvc.perform(
			MockMvcRequestBuilders.put("/recetanueva").content(mapper.writeValueAsString(recetaBody))).andReturn.
			response
		assertEquals(500, responseEntityPut.status)
	}

		@DisplayName("Se crea nueva receta correctamente")
	@Test
	def void testCrearReceta() {
		val recetaBody = getReceta()=>[ id = -1]

		val responseEntityPut = mockMvc.perform(
			MockMvcRequestBuilders.put("/recetanueva").content(mapper.writeValueAsString(recetaBody))).andReturn.
			response
		assertEquals(200, responseEntityPut.status)
		assertEquals(repoRecetas.getById(4).nombreDelPlato, recetaBody.nombreDelPlato)
	}
	
	@DisplayName("Se borra receta Milanesa con id 1")
	@Test
	def void testBorrarReceta() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.delete("/receta/1")).andReturn.response
		assertEquals(200, responseEntity.status)
		assertEquals(repoRecetas.getById(1), null)
	}
	
	
	
	def getReceta(){
		new RecetaSimple => [
						autor = usuario
						setNombreDelPlato= "Lentejas"
		]
	}
	
	static def <T extends Object> fromJson(String json, Class<T> expectedType) {
		mapper.readValue(json, expectedType)
	}
	
	static def <T extends Object> List<T> fromJsonToList(String json, Class<T> expectedType) {
		val type = mapper.getTypeFactory().constructCollectionType(List, expectedType)
		mapper.readValue(json, type)
	}

	static def mapper() {
		new ObjectMapper => [
			configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
			configure(SerializationFeature.INDENT_OUTPUT, true)
		]
	}
}