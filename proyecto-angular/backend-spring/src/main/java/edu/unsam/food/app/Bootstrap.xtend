package edu.unsam.food.app

import edu.unsam.food.repos.RepoRecetas
import edu.unsam.food.domain.RecetaSimple
import edu.unsam.food.domain.UsuarioAutor
import edu.unsam.food.domain.UsuarioPorDefecto
import edu.unsam.food.repos.RepoUsuario
import edu.unsam.food.repos.RepoAlimentos
import edu.unsam.food.domain.Alimento
import edu.unsam.food.domain.GrupoAlimenticio
import edu.unsam.food.domain.Dificultad
import edu.unsam.food.domain.Diabetico
import edu.unsam.food.domain.Vegano
import java.time.LocalDate
import edu.unsam.food.domain.Celiaco
import edu.unsam.food.domain.Ingrediente
import edu.unsam.food.domain.Vegetariano
import edu.unsam.food.domain.Rutina

class Bootstrap {
	
	
	Ingrediente peceto
	val usuario = new UsuarioAutor(new UsuarioPorDefecto("Eduardo Biloni", "edu", 60, 1.70) => [
				agregarAlimentoPreferido(new Alimento("Peceto", GrupoAlimenticio.CARNES_PESCADO_HUEVO))
				password = "1234"
				agregarCondicionAlimenticia(new Diabetico())
				agregarCondicionAlimenticia(new Celiaco())
				fechaDeNacimiento = LocalDate.now()
				rutina = Rutina.LEVE
			])
			
	val usuario2 = new UsuarioAutor(new UsuarioPorDefecto("Lucas Gimenez", "lucas", 80, 1.74)=>[
														   	password = "1234"])
	
		def void run() {
			crearAlimentos()
			crearIngredientes()
			crearRecetas()
			crearUsuarios()
			
	}
 
	def void crearRecetas() {
		
		RepoRecetas.instance => [
			create(new RecetaSimple("Milanesa", usuario)=>[calorias = 1200 
														   dificultad = Dificultad.Media
														  listaDeIngredientes.add(peceto)
														   listaDePasos.add("Cortar el pecetto fino")
														   listaDePasos.add("Romper 2 huevos")
														   listaDeColaboradores.add(usuario2)
			])
			create(new RecetaSimple("Guiso de Lentejas", usuario2)=>[ calorias = 600 dificultad = Dificultad.Facil])
			create(new RecetaSimple("Papas Fritas", usuario)=>[calorias = 800 
														   dificultad = Dificultad.Dificil
														   listaDeIngredientes.add(peceto)
														   listaDePasos.add("Pelar la papa")
														   listaDePasos.add("Cortar la papa")
			])
		]
		
	}

	def void crearUsuarios() {
		RepoUsuario.instance => [

			create(usuario)
			create(new UsuarioPorDefecto("Alberto Sabatini","albertito86", 73, 1.76))
			create(usuario2)
			
			
	]
	}
	
	def void crearAlimentos(){
		RepoAlimentos.instance => [
			create(new Alimento("Peceto", GrupoAlimenticio.CARNES_PESCADO_HUEVO)) => [ inadecuadoPara.add(new Vegano()) inadecuadoPara.add(new Vegetariano())]
			create(new Alimento("Tira de asado", GrupoAlimenticio.CARNES_PESCADO_HUEVO))=> [ inadecuadoPara.add(new Vegano()) inadecuadoPara.add(new Vegetariano())]
			create(new Alimento("Azucar", GrupoAlimenticio.ACEITES_GRASAS_AZUCARES))=> [ inadecuadoPara.add(new Diabetico()) inadecuadoPara.add(new Celiaco())]
			create(new Alimento("Aceite de Girasol", GrupoAlimenticio.CEREALES_LEGUMBRES_DERIVADOS))
		]
	}
	def void crearIngredientes(){
		peceto=new Ingrediente(RepoAlimentos.instance.getById(1),'500')
	}
}