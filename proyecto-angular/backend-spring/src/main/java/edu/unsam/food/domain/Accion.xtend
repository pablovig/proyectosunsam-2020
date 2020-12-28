package edu.unsam.food.domain

import java.time.LocalDate

abstract class Accion {
	
	def void ejecutarAccion(Receta receta)
	
	def void restablecerCambio(Receta receta)
}

class EditarTitulo extends Accion {
	
	String nuevoTitulo
	
	new (String _nuevoTitulo){
		nuevoTitulo = _nuevoTitulo
	}
	
	
	override ejecutarAccion(Receta receta) {
			
		receta.seEditaTitulo(nuevoTitulo, this)
	}
	
	override restablecerCambio(Receta receta) {
		
		receta.seRecuperaTitulo
	}	
}

class EditarDificultad extends Accion {
	
	Dificultad nuevaDificultad
	
	new (Dificultad _nuevaDificultad){
		nuevaDificultad = _nuevaDificultad
	}
	
	override ejecutarAccion(Receta receta) {
		
		receta.seEditaDificultad(nuevaDificultad, this)
	}
	
	override restablecerCambio(Receta receta) {
		
		receta.seRecuperaDificultad()
	}
}

class AgregarColaborador extends Accion {
	
	UsuarioColaborador nuevoColaborador
	
	new (UsuarioColaborador _nuevocolaborador){
		
		nuevoColaborador = _nuevocolaborador
	}
	
	override ejecutarAccion(Receta receta) {
		
		receta.ingresarColaborador((nuevoColaborador))
		receta.ultimaAccion = this
	}
	
	override restablecerCambio(Receta receta) {
		
		receta.removerColaborador(nuevoColaborador)
	}
}

class EliminarPaso extends Accion{
	
	Integer pasoAEliminar
	
	new (Integer _pasoAEliminar){
		
		pasoAEliminar = _pasoAEliminar
	}
		
	override ejecutarAccion(Receta receta) {
		
		receta.seEliminaPaso(pasoAEliminar, this)
	}
	
	override restablecerCambio(Receta receta) {
		
		receta.seRecuperaPaso(pasoAEliminar)
	}
}


class Periodo {

	int año
	int mes
	int dia = 5

	new (int _año, int _mes){
		año = _año
		mes = _mes
	}	
	
	def fecha(){
		var _fecha = LocalDate.of(año, mes, dia)
		return _fecha
	}

}




