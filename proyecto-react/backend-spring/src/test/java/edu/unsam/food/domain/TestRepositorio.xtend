package edu.unsam.food.domain

import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test

import static org.junit.jupiter.api.Assertions.assertFalse
import static org.junit.jupiter.api.Assertions.assertThrows
import static org.junit.jupiter.api.Assertions.assertTrue
import static org.junit.jupiter.api.Assertions.assertEquals
import edu.unsam.food.repos.Repositorio

class TestRepositorio {
	
	Repositorio<UsuarioPorDefecto> testUsuario
	Repositorio<Alimento> testAlimento
	Repositorio<Receta> testReceta
	UsuarioPorDefecto usuario1
	UsuarioPorDefecto usuario2
	UsuarioAutor usuarioAutor1
	Alimento alimento1
	Receta receta1
	Receta receta2
	Receta receta3
	RecetaSimple subreceta1
	Ingrediente ingrediente1
	
	@BeforeEach
	def void init(){
		
	usuarioAutor1 = new UsuarioAutor(usuario1)
	
	}
	
	@Test
	@DisplayName("Crear objeto en repositorio")
	
	def void create(){
		testUsuario = new Repositorio =>[
		create(usuario1 = new UsuarioPorDefecto("Pedro Alvarez", "peal14", 80, 1.80))]
		
		assertTrue(testUsuario.lista.contains(usuario1))
	}
	
	@Test
	@DisplayName("Borrar objeto en repositorio")
	
	def void delete(){
		testUsuario = new Repositorio =>[
		create(usuario1 = new UsuarioPorDefecto("Pedro Alvarez", "peal14", 80, 1.80))]
		
		testUsuario.delete(usuario1)
		
		assertTrue(!testUsuario.lista.contains(usuario1))
	}
	
	@Test
	@DisplayName("Update objeto en repositorio")
	
	def void update(){
		testUsuario = new Repositorio =>[
		create(usuario1 = new UsuarioPorDefecto("Pedro Alvarez", "peal14", 80, 1.80))]
		usuario2 = new UsuarioPorDefecto("Alvarito", "alva", 60 , 1.70)=>[id = 0]
		
		testUsuario.update(usuario2)
		
		assertFalse(testUsuario.lista.contains(usuario1))
		assertTrue(testUsuario.lista.contains(usuario2))
	}
	
	@Test
	@DisplayName("Update objeto en repositorio tira exception")
	
	def void updateException(){
		testUsuario = new Repositorio =>[
		create(usuario1 = new UsuarioPorDefecto("Pedro Alvarez", "peal14", 80, 1.80))]
		usuario2 = new UsuarioPorDefecto("Alvarito", "alva", 60 , 1.70)=>[id = 4]
		
		assertThrows(ExceptionID, [testUsuario.update(usuario2)])	
	}
	
	@Test
	@DisplayName("Obtener via ID objeto de lista")
	
	def void getByID(){
		testUsuario = new Repositorio =>[
		create(usuario1 = new UsuarioPorDefecto("Pedro Alvarez", "peal14", 80, 1.80))]
		
		assertEquals(testUsuario.getById(0), usuario1)
	}
	
	@Test
	@DisplayName("Busqueda en lista de Repo via parte de nombre")
	
	def void searchByNombre(){
		testUsuario = new Repositorio =>[
		create(usuario1 = new UsuarioPorDefecto("Pedro Alvarez", "peal14", 80, 1.80))]
		
		assertTrue(testUsuario.search("alva").contains(usuario1))
	}
	
	@Test
	@DisplayName("Busqueda en lista de Repo via usuario")
	
	def void searchByUser(){
		testUsuario = new Repositorio =>[
		create(usuario1 = new UsuarioPorDefecto("Pedro Alvarez", "peal14", 80, 1.80))]
		
		assertTrue(testUsuario.search("peal14").contains(usuario1))
	}
	
	@Test
	@DisplayName("Busqueda no encuentra usuario por no estar escrito completo")
	
	def void searchByUserIncompleto(){
		testUsuario = new Repositorio =>[
		create(usuario1 = new UsuarioPorDefecto("Pedro Alvarez", "peal14", 80, 1.80))]
		
		assertFalse(testUsuario.search("peal1").contains(usuario1))
	}
	
	@Test
	@DisplayName("Busqueda en lista de Repo Alimento por nombre")
	
	def void searchByNombreAlimento(){
		testAlimento = new Repositorio =>[
		create(alimento1 = new Alimento("Banana", GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS))]
		
		assertTrue(testAlimento.search("Ban").contains(alimento1))
	}
	
	@Test
	@DisplayName("Busqueda en lista de Repo Alimento por descripcion")
	
	def void searchByDescripcionAlimento(){
		testAlimento = new Repositorio =>[
		create(alimento1 = new Alimento("Banana", GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS))]
		
		alimento1.descripcion = "Banana de medio kilo de peso"
		
		assertTrue(testAlimento.search("medio").contains(alimento1))
	}
	
	@Test
	@DisplayName("Busqueda en lista de Repo Receta por nombre")
	
	def void searchByNombreReceta(){
		usuario1 = new UsuarioPorDefecto("Pedro Alvarez", "peal14", 80, 1.80)
		testReceta = new Repositorio =>[
		create(receta1 = new RecetaCompuesta("Milanesa con Papas Fritas", usuarioAutor1))]
		
		assertTrue(testReceta.search("anesa").contains(receta1))
	}
	
	@Test
	@DisplayName("Busqueda en lista de Repo Receta por nombre de Ingredientes en Receta")
	
	def void searchByNombreIngrediente(){
		usuario1 = new UsuarioPorDefecto("Pedro Alvarez", "peal14", 80, 1.80)
		subreceta1 = new RecetaSimple("Milanesa", usuarioAutor1)
		testReceta = new Repositorio =>[
		create(receta1 = new RecetaCompuesta("Milanesa con Papas Fritas", usuarioAutor1))]
		alimento1 = new Alimento("Peceto", GrupoAlimenticio.CARNES_PESCADO_HUEVO)
		ingrediente1 = new Ingrediente(alimento1, "1 Kilo")
		
		subreceta1.ingresarIngrediente(ingrediente1)
		receta1.ingresarReceta(subreceta1)
		assertTrue(testReceta.search("pec").contains(receta1))
	}
	
		
	@Test
	@DisplayName("Busqueda en lista de Repo Receta por nombre de Ingredientes en Subreceta dentro de una RecetaCompuesta")
	
	def void searchByNombreIngredienteEnSubreceta(){
		usuario1 = new UsuarioPorDefecto("Pedro Alvarez", "peal14", 80, 1.80)
		testReceta = new Repositorio =>[
		create(receta1 = new RecetaCompuesta("Milanesa con Papitas Fritas", usuarioAutor1))]
		alimento1 = new Alimento("Papa", GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS)
		ingrediente1 = new Ingrediente(alimento1, "1 Kilo")
		subreceta1 = new RecetaSimple("Papas Fritas", usuarioAutor1)
		
		subreceta1.ingresarIngrediente(ingrediente1)
		receta1.ingresarReceta(subreceta1)
		
		assertTrue(testReceta.search("papa").contains(receta1))
	}
	
	@Test
	@DisplayName("Busqueda en lista de Repo Receta por nombre de Ingredientes en una RecetaSimple dentro Receta Compuesta dentro de una RecetaCompuesta")
	
	def void searchByNombreIngredienteEnSubrecetaDentroDeReceta(){
		usuario1 = new UsuarioPorDefecto("Pedro Alvarez", "peal14", 80, 1.80)
		testReceta = new Repositorio =>[
		create(receta1 = new RecetaCompuesta("Milanesa con Papas Fritas y huevo frito", usuarioAutor1))]
		alimento1 = new Alimento("Huevo prueba", GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS)
		ingrediente1 = new Ingrediente(alimento1, "Media docena")
		receta2 = new RecetaCompuesta("Papas Fritas y huevo frito", usuarioAutor1)
		subreceta1 = new RecetaSimple("Huevo Frito", usuarioAutor1)
		
		subreceta1.ingresarIngrediente(ingrediente1)
		receta2.ingresarReceta(subreceta1)
		receta1.ingresarReceta(receta2)
		
		assertTrue(testReceta.search("Prueba").contains(receta1))
	}

}