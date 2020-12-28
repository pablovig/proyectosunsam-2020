package edu.unsam.food.domain

import java.util.ArrayList
import java.util.HashSet
import java.util.List
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test

import static org.junit.jupiter.api.Assertions.assertEquals
import static org.junit.jupiter.api.Assertions.assertFalse
import static org.junit.jupiter.api.Assertions.assertTrue

class TestUsuario {
	
	UsuarioPorDefecto usuario1 
	UsuarioPorDefecto usuario2
	UsuarioColaborador usuarioColaborador1
	UsuarioColaborador usuarioColaborador2
	UsuarioAutor usuarioAutor1
	UsuarioAutor usuarioAutor2
	RecetaSimple subreceta1
	RecetaSimple subreceta2
	RecetaSimple subreceta3
	Alimento alimento1
	Alimento alimento2
	Alimento alimento3
	Ingrediente ingrediente1
	Ingrediente ingrediente2
	Ingrediente ingrediente3
	CondicionAlimenticia condicion1
	CondicionAlimenticia condicion2
	RegistroCopias registro1
	Periodo per1
	
	@BeforeEach
	def void init(){
		
		
	}
	
	@Test
	@DisplayName("Medicion de IMC")
	def void medirIMC(){
		
		usuario1 = new UsuarioPorDefecto("Pedro Alvarez", "pealvarez14", 76.8, 1.6 )
		
		assertEquals(30, usuario1.calcularIMC, 0.1)
		
	}
	
	@Test
	@DisplayName("Usuario es saludable por condicion de IMC")
	def void esSaludableXIMC(){
		
		usuario1 = new UsuarioPorDefecto("Pedro Alvarez", "pealvarez14", 76.8, 1.6 )
		
		assertTrue(usuario1.esSaludable)
	}
	
	@Test
	@DisplayName("Usuario no es saludable por ambas condiciones")
	def void noEsSaludableXIMCYCondicion(){
		
		usuario1 = new UsuarioPorDefecto("Jorge Zarate", "zar90", 110, 1.5)

		usuario1.agregarCondicionAlimenticia(new Vegano)
		
		assertFalse(usuario1.esSaludable)
	}
		
	@Test
	@DisplayName("Usuario es saludable por condicion de alimento")
	def void esSaludableXCondicionDiabetico(){
		

		usuario1 = new UsuarioPorDefecto("Miguel Suarez", "miguelito", 71, 1.5)
		
		usuario1.agregarCondicionAlimenticia(new Diabetico) 
		usuario1.rutina = Rutina.ACTIVO
		
		assertTrue(usuario1.esSaludable)

	}
	
	@Test
	@DisplayName("Usuario es saludable por condicion de Vegano")
	def void esSaludableXVegano(){
		

		usuario1 = new UsuarioPorDefecto("Carlos Tevez", "elapache09", 71, 1.5)
		
		usuario1.agregarCondicionAlimenticia(new Vegano)
		usuario1.agregarAlimentoPreferido(new Alimento("Pera", GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS))
		usuario1.agregarAlimentoPreferido(new Alimento("Manzana", GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS))
		
		assertTrue(usuario1.esSaludable)

	}
	
	@Test
	@DisplayName("Usuario no es saludable por condicion de Vegetariano")
	def void noEsSaludableXVegatariano(){
		

		usuario1 = new UsuarioPorDefecto("Tom", "tomguirz", 71, 1.5)
		
		usuario1.agregarCondicionAlimenticia(new Vegetariano) 
		usuario1.agregarAlimentoPreferido(new Alimento("Bizcocho de Grasa", GrupoAlimenticio.ACEITES_GRASAS_AZUCARES))
		
		assertFalse(usuario1.esSaludable)

	}
	
	@Test
	@DisplayName("Usuario es valido por todas condiciones")
	def void esValido(){
		
		usuario1 = new UsuarioPorDefecto("Pedro Alvarez", "pealvarez14", 76.8, 1.6 )
		
		usuario1.agregarCondicionAlimenticia(new Hipertenso) 
		usuario1.establecerFecha("2020-02-02")
		usuario1.rutina = Rutina.ACTIVO
		usuario1.agregarAlimentoPreferido(new Alimento("Sandia", GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS))
		
		assertTrue(usuario1.esValido)
	}
	
	@Test
	@DisplayName("Usuario no es valido por Fecha")
	def void noEsValidoXFecha(){
		
		usuario1 = new UsuarioPorDefecto("Pedro Alvarez", "pealvarez14", 76.8, 1.6 )
		
		usuario1.establecerFecha("2021-06-10")
		usuario1.agregarCondicionAlimenticia(new Hipertenso) 

		usuario1.rutina = Rutina.ACTIVO
		usuario1.agregarAlimentoPreferido(new Alimento("Sandia", GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS))
		
		assertFalse(usuario1.esValido)
	}
	
	@Test
	@DisplayName("Usuario no es valido por nombre")
	def void noEsValidoXNombre(){
		
		usuario1 = new UsuarioPorDefecto("Tom", "tomguirz", 71, 1.5)
		
		usuario1.establecerFecha("2020-04-09")
		usuario1.rutina = Rutina.ACTIVO
		usuario1.agregarCondicionAlimenticia(new Vegetariano)
		
		assertFalse(usuario1.esValido)
	}
	
	@Test
	@DisplayName("Usuario diabetico no es valido por no tener alimento preferido")
	def void noEsValidoXRutina(){

		usuario1 = new UsuarioPorDefecto("Miguel Suarez", "miguelito", 71, 1.5)
		
		usuario1.agregarCondicionAlimenticia(new Diabetico) 
		usuario1.rutina = Rutina.ACTIVO
		
		assertFalse(usuario1.esValido)
	}
	
	@Test
	@DisplayName("Usuario genera copia de una Receta")
	def void copiarReceta(){
		usuario1 = new UsuarioPorDefecto("Jorge Zarate", "zar90", 110, 1.5)
		usuario2 = new UsuarioPorDefecto("Miguel Suarez", "miguelito", 71, 1.5)
		usuarioAutor1 = new UsuarioAutor(usuario1)
		
		subreceta1 = new RecetaSimple ("Ensalada", usuarioAutor1 )
		alimento1 = new Alimento("Lechuga", GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS)
		ingrediente1 = new Ingrediente(alimento1, "500")
		
		subreceta1.ingresarIngrediente(ingrediente1)
		
		assertTrue(usuario2.generarCopia(subreceta1).getNombreDelPlato.contains("Ensalada"))
	}
	
	@Test
	@DisplayName("Sugerencia individual para Vegetariano")
	def void sugerenciaIndividual(){
		var List<Receta> recetas = new ArrayList <Receta>
		condicion1 = new Vegetariano
		usuario1 = new UsuarioPorDefecto("Jorge Zarate", "zar90", 110, 1.5)
		usuarioAutor1 = new UsuarioAutor(usuario1)
		subreceta1 = new RecetaSimple ("Ensalada", usuarioAutor1 )
		alimento1 = new Alimento("Lechuga", GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS)
		ingrediente1 = new Ingrediente(alimento1, "500")
		
		usuario1.agregarCondicionAlimenticia(condicion1)
		subreceta1.ingresarIngrediente(ingrediente1)
		recetas.add(subreceta1)
		
		assertEquals(usuario1.sugerenciaIndividual(recetas),subreceta1)
	
		
	}
	
	@Test
	@DisplayName("Sugerencia Grupal por condicion y por Disgustado")
	def void sugerenciaGrupal(){
		
		var List<Receta> recetas = new ArrayList <Receta>
		var List<Usuario> usuarios = new ArrayList<Usuario>
		var HashSet<Receta> listTest = new HashSet<Receta>
		
		condicion1 = new Vegetariano
		condicion2 = new Diabetico
		usuario1 = new UsuarioPorDefecto("Jorge Zarate", "zar90", 110, 1.5)
		usuario2 = new UsuarioPorDefecto("Tom", "tomguirz", 71, 1.5)
		usuarioAutor1 = new UsuarioAutor(usuario1)
		usuarioAutor2 = new UsuarioAutor(usuario2)
		subreceta1 = new RecetaSimple ("Carne al horno", usuarioAutor2 )
		subreceta2 = new RecetaSimple("Ensalada Cesar", usuarioAutor2)
		subreceta3 = new RecetaSimple("Papa rellena de Muzarella", usuarioAutor1)
		alimento1 = new Alimento("Carne", GrupoAlimenticio.CARNES_PESCADO_HUEVO)=>[agregarInadecuado(condicion1)]
		alimento2 = new Alimento("Lechuga",GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS)=>[agregarInadecuado(condicion2)]
		alimento3 = new Alimento("Papa",GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS)
		ingrediente1 = new Ingrediente(alimento1, "500g sin grasa")
		ingrediente2 = new Ingrediente(alimento2, "1 Planta")
		ingrediente3 = new Ingrediente(alimento3, "1 Kilo")
		
		usuario1.agregarCondicionAlimenticia(condicion1)  // descarta la subreceta1 x condicion
		usuario2.agregarAlimentoDisgustado(alimento2)	// descarta la Ensalada Cesar x disgustado
		subreceta1.ingresarIngrediente(ingrediente1)
		subreceta2.ingresarIngrediente(ingrediente2)
		subreceta3.ingresarIngrediente(ingrediente3)
		usuarios.add(usuario1)
		usuarios.add(usuario2)
		recetas.add(subreceta1)
		recetas.add(subreceta2)
		recetas.add(subreceta3)
		listTest.add(subreceta3)
	
		assertEquals(usuario1.sugerenciaGrupal(recetas,usuarios), subreceta3)
		
	}
	
	@Test
	@DisplayName("Sugerencia Grupal Exception")
	def void sugerenciaGrupalException(){
		
		
		var List<Receta> recetas = new ArrayList <Receta>
		var List<Usuario> usuarios = new ArrayList<Usuario>
		var HashSet<Receta> listTest = new HashSet<Receta>
		
		condicion1 = new Vegetariano
		condicion2 = new Diabetico
		usuario1 = new UsuarioPorDefecto("Jorge Zarate", "zar90", 110, 1.5)
		usuario2 = new UsuarioPorDefecto("Tom", "tomguirz", 71, 1.5)
		usuarioAutor1 = new UsuarioAutor(usuario1)
		usuarioAutor2 = new UsuarioAutor(usuario2)
		subreceta1 = new RecetaSimple ("Carne al horno", usuarioAutor2 )
		subreceta2 = new RecetaSimple("Ensalada Cesar", usuarioAutor2)
		subreceta3 = new RecetaSimple("Papa rellena de Muzarella", usuarioAutor1)
		alimento1 = new Alimento("Carne", GrupoAlimenticio.CARNES_PESCADO_HUEVO)=>[agregarInadecuado(condicion1)]
		alimento2 = new Alimento("Lechuga",GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS)=>[agregarInadecuado(condicion2)]
		alimento3 = new Alimento("Papa",GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS)
		ingrediente1 = new Ingrediente(alimento1, "500g sin grasa")
		ingrediente2 = new Ingrediente(alimento2, "1 Planta")
		ingrediente3 = new Ingrediente(alimento3, "1 Kilo")
		
		usuario1.agregarCondicionAlimenticia(condicion1)  // descarta la subreceta1 x condicion
		usuario2.agregarAlimentoDisgustado(alimento2)	// descarta la Ensalada Cesar x disgustado
		subreceta1.ingresarIngrediente(ingrediente1)
		subreceta2.ingresarIngrediente(ingrediente2)
		subreceta3.ingresarIngrediente(ingrediente3)
		usuarios.add(usuario1)
		usuarios.add(usuario2)
		recetas.add(subreceta1)
		recetas.add(subreceta2)
		
		listTest.add(subreceta1)
		listTest.add(subreceta2)
	
		assertEquals(usuario1.sugerenciaGrupal(recetas,usuarios), listTest)
		
	}
	
	@Test
	@DisplayName("Usuario envía mail, se corrobora recepcion y lectura de mail")
	def void envioDeMail(){
		
		usuario1 = new UsuarioPorDefecto("Jorge Zarate", "zar90", 110, 1.5)
		usuario2 = new UsuarioPorDefecto("Miguel Suarez", "miguelito", 71, 1.5)
		//CorreoElectronico = MailSender.instance

		
		usuario1.enviarMensaje("Hola como estas", usuario2)
		
		assertFalse(usuario2.bandejaDeEntrada.empty)
		assertEquals("Hola como estas",usuario2.leerMensaje(0))
		assertTrue(usuario2.bandejaDeEntrada.get(0).mensajeLeido)
	}
	
	@Test
	@DisplayName("Colaborador sugiere nuevo titulo para receta y es autorizado por Autor, y deshacer el mismo")
	def void autorAutorizaCambioDeTitulo(){
		
		usuarioColaborador1 = new UsuarioColaborador(new UsuarioPorDefecto("Jorge Zarate", "zar90", 110, 1.5))
		usuarioAutor1 = new UsuarioAutor (new UsuarioPorDefecto("Miguel Suarez", "miguelito", 71, 1.5))
		subreceta1 = new RecetaSimple ("Ensalada", usuarioAutor1 )
		
		subreceta1.ingresarColaborador(usuarioColaborador1)
		usuarioColaborador1.solicitarCambioDeTitulo(subreceta1,"EnsaladaSuper")
		usuarioAutor1.autorizarCambio(subreceta1,0)
		
		assertEquals("EnsaladaSuper",subreceta1.getNombreDelPlato)
		
		subreceta1.deshacerCambio()
		
		assertEquals("Ensalada",subreceta1.getNombreDelPlato)
		}
		
	@Test
	@DisplayName("Colaborador sugiere nueva dificultad para receta simple y es autorizado por Autor, y deshacer el mismo")
	def void autorAutorizaCambioDeDificultad(){
		
		usuarioColaborador1 = new UsuarioColaborador(new UsuarioPorDefecto("Jorge Zarate", "zar90", 110, 1.5))
		usuarioAutor1 = new UsuarioAutor (new UsuarioPorDefecto("Miguel Suarez", "miguelito", 71, 1.5))
		subreceta1 = new RecetaSimple ("Ensalada", usuarioAutor1 )
		
		subreceta1.dificultad = Dificultad.Media
		subreceta1.ingresarColaborador(usuarioColaborador1)
		usuarioColaborador1.solicitarCambioDeDificultad(subreceta1, Dificultad.Facil)
		usuarioAutor1.autorizarCambio(subreceta1,0)
		
		assertEquals(Dificultad.Facil,subreceta1.dificultad)
		
		subreceta1.deshacerCambio()
		
		assertEquals(Dificultad.Media,subreceta1.dificultad)
		}
		
	@Test

	@DisplayName("Colaborador sugiere agregar otro colaborador en la receta y es autorizado por Autor, y deshacer el mismo")
	def void autorAutorizaOtroColaborador(){
		
		usuarioColaborador1 = new UsuarioColaborador(new UsuarioPorDefecto("Jorge Zarate", "zar90", 110, 1.5))
		usuarioColaborador2 = new UsuarioColaborador (new UsuarioPorDefecto("Juan Zarate", "zar78", 115, 1.8))
		usuarioAutor1 = new UsuarioAutor (new UsuarioPorDefecto("Miguel Suarez", "miguelito", 71, 1.5))
		subreceta1 = new RecetaSimple ("Ensalada", usuarioAutor1 )
		
		subreceta1.ingresarColaborador(usuarioColaborador1)
		usuarioColaborador1.solicitarAgregarColaborador(subreceta1,usuarioColaborador2)
		usuarioAutor1.autorizarCambio(subreceta1,0)
		
		assertTrue(subreceta1.listaDeColaboradores.contains(usuarioColaborador2))
		
		subreceta1.deshacerCambio()
		
		assertFalse(subreceta1.listaDeColaboradores.contains(usuarioColaborador2))
		}
		
	@Test
	@DisplayName("Colaborador sugiere eliminar un paso de la receta y es autorizado por Autor, y deshacer el mismo")
	def void autorAutorizaEliminarPaso(){
		
		usuarioColaborador1 = new UsuarioColaborador(new UsuarioPorDefecto("Jorge Zarate", "zar90", 110, 1.5))
		usuarioColaborador2 = new UsuarioColaborador (new UsuarioPorDefecto("Juan Zarate", "zar78", 115, 1.8))
		usuarioAutor1 = new UsuarioAutor (new UsuarioPorDefecto("Miguel Suarez", "miguelito", 71, 1.5))
		subreceta1 = new RecetaSimple ("Ensalada", usuarioAutor1 )
		
		subreceta1.ingresarColaborador(usuarioColaborador1)
		subreceta1.ingresarPaso("Se corta la lechuga")
		
		assertEquals(1,subreceta1.listaDePasos.size) // Se verifica que hay un paso cargado
		
		usuarioColaborador1.solicitarEliminarPaso(subreceta1,0)
		usuarioAutor1.autorizarCambio(subreceta1,0)
		
		assertEquals(0,subreceta1.listaDePasos.size) // Se verifica que el paso fue eliminado
		
		subreceta1.deshacerCambio()
		
		assertEquals("Se corta la lechuga",subreceta1.listaDePasos.get(0))
	}
	
	@Test
	@DisplayName("Se envia mensaje al autor al realizar copia")
	def void mensajeAutor(){

		usuario1 = new UsuarioPorDefecto("Jorge Zarate", "zar90", 110, 1.5)
		usuarioAutor2 = new UsuarioAutor(new UsuarioPorDefecto("Miguel Suarez", "miguelito", 71, 1.5))
		subreceta1 = new RecetaSimple ("Ensalada", usuarioAutor2 ) =>[ copyObservers.add(new MensajeAutor)]

		usuario1.generarCopia(subreceta1)
		
		assertTrue(usuarioAutor2.leerMensaje(0).contains("Hice una copia de tu receta Ensalada"))
		}
		
	@Test
	@DisplayName("Se envia mensaje a colaboradores al realizar copia")
	def void mensajeColaborador(){
		
		usuario1 = new UsuarioPorDefecto("Jorge Zarate", "zar90", 110, 1.5)
		usuarioColaborador1 = new UsuarioColaborador(new UsuarioPorDefecto("Miguel Suarez", "miguelito", 71, 1.5))
		usuarioColaborador2 = new UsuarioColaborador(new UsuarioPorDefecto("Miguel Guiri", "miguiri", 71, 1.8))
		subreceta1 = new RecetaSimple ("Ensalada", usuarioAutor1 ) =>[ copyObservers.add(new MensajeColaborador)
																  listaDeColaboradores.add(usuarioColaborador1)
																  listaDeColaboradores.add(usuarioColaborador2)
																]

		usuario1.generarCopia(subreceta1)
		assertEquals(usuarioColaborador1.leerMensaje(0), "zar90 generó copia de la Receta Ensalada")
		assertTrue(usuarioColaborador2.leerMensaje(0).contains("zar90 generó copia de la Receta Ensalada"))
		}
		
	@Test
	@DisplayName("Registro contador de recetas Faciles")
	def void registroContadorPorDificultad(){
		
		usuarioAutor1 = new UsuarioAutor(new UsuarioPorDefecto("Jorge Zarate", "zar90", 110, 1.5))
		subreceta1 = new RecetaSimple ("Ensalada", usuarioAutor1 ) =>[ dificultad = Dificultad.Facil
																  copyObservers.add(registro1 = new RegistroCopias)
		assertEquals(registro1.cantFacil, 0)													]
		
		usuarioAutor1.generarCopia(subreceta1)
		usuarioAutor1.generarCopia(subreceta1)
		subreceta1.dificultad = Dificultad.Dificil
		usuarioAutor1.generarCopia(subreceta1)
		
		assertEquals(registro1.cantFacil, 2)
		assertEquals(registro1.cantDificil, 1)
		}
		
	@Test
	@DisplayName("Registro contador por autor")
	def void registroContadorPorAutor(){
		
		usuarioAutor1 = new UsuarioAutor(new UsuarioPorDefecto("Jorge Zarate", "zar90", 110, 1.5))
		usuario2 = new UsuarioPorDefecto("Damian", "peperoni", 70, 1.77)
		subreceta1 = new RecetaSimple ("Ensalada", usuarioAutor1 ) =>[ 
																  copyObservers.add(registro1 = new RegistroCopias)
																]
		usuario2.generarCopia(subreceta1)
		usuario2.generarCopia(subreceta1)
		assertEquals(usuarioAutor1.cantCopiasAutor, 2)
		}
		
	@Test
	@DisplayName("Registro contador por no autores")
	def void registroContadorPorNoAutor(){
		
		usuarioAutor1 = new UsuarioAutor(new UsuarioPorDefecto("Jorge Zarate", "zar90", 110, 1.5))
		usuario2 = new UsuarioPorDefecto("Damian", "peperoni", 70, 1.77)
		subreceta1 = new RecetaSimple ("Ensalada", usuarioAutor1 ) =>[ 
																  copyObservers.add(registro1 = new RegistroCopias)
																]
		usuario2.generarCopia(subreceta1)
		usuario2.generarCopia(subreceta1)
		usuarioAutor1.generarCopia(subreceta1)
		assertEquals(registro1.cantNoAutor, 2)
		}	
		
		
}





