package edu.unsam.food.repos
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.List
import edu.unsam.food.domain.Entidad
import edu.unsam.food.domain.ExceptionID
import java.util.ArrayList

@Accessors
class Repositorio<T extends Entidad> {
	
	 List<T> lista = new ArrayList()
	 Integer idRepo = 1
	
	new (){
		
	}
	
	def create(T object) {
		lista.add(object)
		object.id = idRepo
		idRepo++
		return object
	}

	def delete(T object) {
		lista.remove(object)
	}
	
	def deleteById(int id){
		lista.remove(getById(id))
	}

	def update(T object) {
		try {
			lista.remove(getById(object.id))
		} catch (Exception error) {
			throw new ExceptionID("ID inexistente.")
		}
		lista.add(object)
	}

	def T getById(int id) {
		lista.filter[objetos|objetos.id == id].head
	}

	def List<T> search(String value) {	
		lista.filter[objetos | objetos.busqueda(value)].toList
	}	
	
}





