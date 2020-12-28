package edu.unsam.food.domain

import org.eclipse.xtend.lib.annotations.Accessors

abstract class CopyObserver {    //generada como abstract class ya que Travis sino tira error.
	def void copiaGenerada(Receta _receta, Usuario usuario){}
}

class MensajeAutor extends CopyObserver{
	
	override void copiaGenerada(Receta _receta, Usuario usuario){
		var localString = String.format("Hice una copia de tu receta %s", _receta.getNombreDelPlato)
		usuario.enviarMensaje(localString, _receta.autor)
	}
}

class MensajeColaborador extends CopyObserver{
	
	override void copiaGenerada(Receta _receta, Usuario usuario){
		val localString = String.format("%s generó copia de la Receta %s", usuario.username, _receta.getNombreDelPlato)
		_receta.listaDeColaboradores.forEach[ colaborador | usuario.enviarMensaje(localString, colaborador) ] // Quien manda mail?
		
	}
}

@Accessors
class RegistroCopias extends CopyObserver{
	
	int cantFacil = 0
	int cantMedia = 0
	int cantDificil = 0
	int cantNoAutor = 0
	
	
	override void copiaGenerada(Receta _receta, Usuario usuario){
		copiaDificultad(_receta, usuario)
		copiaAutor(_receta, usuario)
		copiaNoAutor(_receta, usuario)
	}
	
	def void copiaDificultad(Receta _receta, Usuario usuario){
		
		if(_receta.dificultadCompuesta == Dificultad.Facil){
			cantFacil++;
		}
		
		if(_receta.dificultadCompuesta == Dificultad.Media){
			cantMedia++;
		}
		
		if(_receta.dificultadCompuesta == Dificultad.Dificil){
			cantDificil++;
		}
	}
	
	def copiaAutor(Receta _receta, Usuario usuario){
		
		_receta.sumarCopiaAutor
		
	}
	
	def void copiaNoAutor(Receta _receta, Usuario usuario){
		
		if (!usuario.esAutor){
			cantNoAutor++
		}
	}
	
	
}