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
import edu.unsam.food.domain.UsuarioPorDefecto
import org.junit.jupiter.api.AfterEach
import edu.unsam.food.repos.RepoMensajes
import edu.unsam.food.repos.RepoUsuario
import edu.unsam.food.domain.Mensaje
import org.springframework.test.annotation.DirtiesContext

@AutoConfigureJsonTesters
@ContextConfiguration(classes=MailController)
@WebMvcTest
@DirtiesContext
@DisplayName("Testeo de un MailController")
class MailControllerTest {
	
	@Autowired
	MockMvc mockMvc
	RepoMensajes repoMensajes = RepoMensajes.instance
	RepoUsuario repoUsuario = RepoUsuario.instance
	UsuarioPorDefecto usuarioEmisor
	UsuarioPorDefecto usuarioReceptor
	
		
	
	@BeforeEach
	def void init() {
		repoMensajes.lista.clear
		usuarioEmisor = new UsuarioPorDefecto("Demian","demi14", 1.80, 80)
		usuarioReceptor = new UsuarioPorDefecto("Manuel","manu", 1.80, 80)
		
		
		repoUsuario => [
			create(usuarioEmisor)
			create(usuarioReceptor)
			//create(usuarioLogueado)
		]
		
				
		repoMensajes => [
			create(new Mensaje("Hola!!", usuarioEmisor))
			create(new Mensaje("Hola2!!", usuarioReceptor))
		]
		
		//usuarioEmisor.enviarMensaje("Que haces man", usuarioReceptor)
		//usuarioEmisor.enviarMensaje("A que hora nos juntamos", usuarioReceptor)
	}
	
	@AfterEach
	def void end(){
		repoMensajes.lista.clear
		repoMensajes.idRepo = 1
	}
	
	@DisplayName("Se obtiene un mensaje por ID")
	@Test
	def void testMensajePorId() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/mensajes/1")).andReturn.response
		val mensajeBuscado = responseEntity.contentAsString.fromJson(Mensaje)
		assertEquals(200, responseEntity.status)
		assertEquals(mensajeBuscado.cuerpoDeMensaje, "Que haces man")
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