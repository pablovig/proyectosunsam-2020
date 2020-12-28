package edu.unsam.food.domain

import java.util.HashSet
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test

import static org.junit.jupiter.api.Assertions.*
import static org.junit.jupiter.api.Assertions.assertEquals
import static org.junit.jupiter.api.Assertions.assertFalse
import static org.junit.jupiter.api.Assertions.assertTrue


class TestReceta {
	
	
	RecetaCompuesta receta1
	RecetaCompuesta receta2
	RecetaSimple subreceta1
	RecetaSimple subreceta2
	UsuarioPorDefecto usuario1
	UsuarioPorDefecto usuario2
	Alimento alimento1
	Alimento alimento2
	CondicionAlimenticia condicion1
	CondicionAlimenticia condicion2
	Ingrediente ingrediente1
	Ingrediente ingrediente2
	UsuarioColaborador usuarioColaborador1
	UsuarioColaborador usuarioColaborador2
	UsuarioAutor usuarioAutor1
	UsuarioAutor usuarioAutor2
	

	@BeforeEach
	def void init(){
		usuarioAutor1 = new UsuarioAutor(usuario1)
		usuario1 = new UsuarioPorDefecto("Damian Cho", "chori14", 60, 1.6 )
		usuario2 = new UsuarioPorDefecto("Tito Zilber", "tito", 65, 1.7 )
	
	}
	
	@Test
	@DisplayName("Test con usuario autor y no autor")
	
	def void testAutor(){
		
		receta1 = new RecetaCompuesta("Milanesa con Ensalada", usuarioAutor1)
		
		assertTrue(receta1.esEditable(usuarioAutor1))
		assertFalse(receta1.esEditable(usuario2))
		
	}
	
	@Test
	@DisplayName("Test con usuario colaborador y no colaborador")
	
	def void testColaborador(){
		
		receta1 = new RecetaCompuesta("Milanesa con Ensalada", usuarioAutor1)
		
		assertFalse(receta1.esEditable(usuario2))
		receta1.ingresarColaborador(usuario2)
		assertTrue(receta1.esEditable(usuario2))
		
	}
	
	@Test
	@DisplayName("Receta sin subrecetas anidadas no es valida por no tener calorias")
	
	def void esValida(){
		
		receta1 = new RecetaCompuesta("Milanesa con Ensalada", usuarioAutor1)
	
		receta1.ingresarPaso("Cortar el peceto grosor a gusto")
		
		assertFalse(receta1.esValida)
	}
	
	@Test
	@DisplayName("Receta sin subrecetas anidadas, no es valida por tener pocas calorias")
	
	def void noValidaXCalorias(){
		
		subreceta1 = new RecetaSimple("Milanesa con Ensalada", usuarioAutor1)
		
		subreceta1.calorias = 5
		
		assertFalse(subreceta1.esValida)
	}
	
	@Test
	@DisplayName("Subreceta con aliemento, no es valida por no tener pasos")
	
	def void noValidaXPasos(){
		
		subreceta1 = new RecetaSimple ("Ensalada", usuarioAutor1 )
		subreceta1.dificultad = Dificultad.Media
		subreceta1.calorias = 2000
		subreceta1.ingresarIngrediente(new Ingrediente(alimento2, "Medio Repollo"))
		
		assertFalse(subreceta1.esValida)
	}
	
	@Test
	@DisplayName("Receta con subreceta anidada (ambas validas), no es valida por exceso de calorias")
	
	def void recetaConSubrecetaNovalidaXCalorias(){
		
		receta1 = new RecetaCompuesta("Milanesa con Ensalada", usuarioAutor1)
		subreceta1 = new RecetaSimple ("Ensalada", usuarioAutor2 )
		alimento1 = new Alimento("Lechuga", GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS)
		alimento2 = new Alimento("Tomate", GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS)
		ingrediente1 = new Ingrediente(alimento1, "1 Planta")
		ingrediente2 = new Ingrediente(alimento2, "4 Peritas")
		
		subreceta1.ingresarIngrediente(ingrediente1)
		subreceta1.ingresarIngrediente(ingrediente2)
		subreceta1.calorias = 6000
		
		receta1.ingresarReceta(subreceta1)
		receta1.ingresarPaso("Cortar el peceto grosor a gusto")
		
		assertFalse(receta1.esValida)
	}
	
	@Test
	@DisplayName("Calorias de Receta Compuesta con dos subrecetas ")
	
	def void RecetaCompuestaCalorias(){
		
		receta1 = new RecetaCompuesta("Milanesa con Ensalada y Huevo Frito", usuarioAutor1)
		subreceta1 = new RecetaSimple ("Ensalada", usuarioAutor2 ) => [calorias = 1000]
		subreceta2 = new RecetaSimple ("Huevo Frito", usuarioAutor2 ) => [calorias = 3000]
		
		receta1.ingresarReceta(subreceta1)
		receta1.ingresarReceta(subreceta2)
		
		assertEquals(4000,receta1.caloriasTotales)
	}
	

	@Test
	@DisplayName("Lista total de pasos en receta compuesta que anida otra compuesta con simple")
	
	def void RecetaCompuestaListaPasos(){
		
		receta1 = new RecetaCompuesta("Milanesa con Ensalada", usuarioAutor1)
		receta2 = new RecetaCompuesta("Milanesa con Huevo Frito, con Ensalada", usuarioAutor1) 
		subreceta1 = new RecetaSimple ("Ensalada", usuarioAutor2 )
		
		subreceta1.ingresarPaso("Cortar lechuga y tomate")
		receta1.ingresarPaso("Cortar Peceto")
		receta2.ingresarPaso("Colocar aceite en sarten")
		receta1.ingresarReceta(subreceta1)
		receta2.ingresarReceta(receta1)
		
		assertTrue(receta2.listaTotalPasos.contains("Cortar lechuga y tomate"))
	}
	 
	
	@Test
	@DisplayName("Lista de ingredientes con cantidades")
	
	def void listaConCantidades(){
		
		
	}
	
 	@Test
	@DisplayName("Receta con alimentos inadecuados")
	
	def void inadecuadoPara(){
		
		var HashSet<CondicionAlimenticia> listaPrueba = new HashSet<CondicionAlimenticia>
		
		receta1 = new RecetaCompuesta("Milanesa con Ensalada", usuarioAutor1)
		subreceta1 = new RecetaSimple ("Ensalada", usuarioAutor2 )
		alimento1 = new Alimento("Peceto", GrupoAlimenticio.CARNES_PESCADO_HUEVO)
		alimento2 = new Alimento("Lechuga", GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS)
		condicion1 = new Vegano
		condicion2 = new Diabetico
		
		alimento1.agregarInadecuado(condicion1)
		alimento2.agregarInadecuado(condicion2)
		subreceta1.ingresarIngrediente(new Ingrediente(alimento1, "500"))
		subreceta1.ingresarIngrediente(new Ingrediente(alimento2, "1 Planta"))
    
		receta1.ingresarReceta(subreceta1)
		listaPrueba.add(condicion1)
		listaPrueba.add(condicion2)
	
		assertTrue(receta1.inadecuadaPara.contains(condicion1))
		assertTrue(receta1.inadecuadaPara.contains(condicion2))
		assertEquals(receta1.inadecuadaPara, listaPrueba)
	}
	
	
	@Test
	@DisplayName("Lista con ingredientes de subrecetas")
	
	def void subrecetaIngredientes(){
		
		receta1 = new RecetaCompuesta("Milanesa con Ensalada", usuarioAutor1)
		subreceta1 = new RecetaSimple ("Ensalada", usuarioAutor2 )
		alimento1 = new Alimento("Peceto", GrupoAlimenticio.CARNES_PESCADO_HUEVO)
		alimento2 = new Alimento("Lechuga", GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS)
		ingrediente1 = new Ingrediente(alimento1, "500")
		ingrediente2 = new Ingrediente(alimento2, "500")

		subreceta1.ingresarIngrediente(ingrediente1)
		subreceta1.ingresarIngrediente(ingrediente2)
		receta1.ingresarReceta(subreceta1)
		
		assertTrue(receta1.totalIngredientes.contains(ingrediente1))
		assertTrue(receta1.totalIngredientes.contains(ingrediente2))
		
	}
	
	@Test
	@DisplayName("Copia de Subreceta")
	
	def void copiaSubreceta(){
		
		subreceta1 = new RecetaSimple ("Ensalada", usuarioAutor2 )
		alimento1 = new Alimento("Lechuga", GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS)
		ingrediente1 = new Ingrediente(alimento1, "500")
		
		subreceta1.calorias = 3000
		subreceta1.ingresarIngrediente(ingrediente1)
		
		assertTrue(subreceta1.generarCopia(usuarioAutor1).autor == usuarioAutor1)
		assertTrue(subreceta1.generarCopia(usuarioAutor1).listaDeIngredientes.contains(ingrediente1))
		    
	}
	
	
	@Test
	@DisplayName("Copia de Receta Compuesta")
	
	def void copiaRecetaCompuesta(){
		subreceta1 = new RecetaSimple ("Papas Fritas", usuarioAutor2 )
		receta1 = new RecetaCompuesta ("Milanesa con papas fritas", usuarioAutor2 )
		alimento1 = new Alimento("Papa", GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS)
		ingrediente1 = new Ingrediente(alimento1, "500")
		
		
		subreceta1.calorias = 3000
		subreceta1.ingresarIngrediente(ingrediente1)
		receta1.ingresarReceta(subreceta1)
		
		receta1.subrecetas.contains(subreceta1)
		assertTrue(receta1.generarCopia(usuarioAutor1).subrecetas.contains(subreceta1))	   
	}
	
	@Test
	@DisplayName("Se retorna el grado de dificultad Mayor")
	
	def void testDificultadCompuesta(){
		subreceta1 = new RecetaSimple ("Papas Fritas", usuarioAutor2 ) => [dificultad = Dificultad.Dificil ]
		subreceta2 = new RecetaSimple ("Papas Fritas", usuarioAutor2 ) => [dificultad = Dificultad.Media ]
		receta1 = new RecetaCompuesta ("Milanesa con papas fritas", usuarioAutor2 )

		receta1.ingresarReceta(subreceta2)
		
		assertEquals(receta1.dificultadCompuesta,Dificultad.Media)
		
		receta1.ingresarReceta(subreceta1)
		
		assertEquals(receta1.dificultadCompuesta,Dificultad.Dificil)
	}
}