package edu.unsam.food.domain

import java.util.ArrayList
import java.util.HashSet
import java.util.List
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors
import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.fasterxml.jackson.annotation.JsonTypeName
import com.fasterxml.jackson.annotation.JsonProperty
import com.fasterxml.jackson.annotation.JsonIgnore

@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY, property = "type")
@JsonSubTypes( @JsonSubTypes.Type(name = "recetaSimple", value = RecetaSimple ), @JsonSubTypes.Type(value = RecetaCompuesta, name = "recetaCompuesta") )
@Accessors abstract class Receta extends Entidad{

	String nombreDelPlato
	@JsonIgnore String ultimoNombre
	Usuario autor
	List<Usuario> listaDeColaboradores = new ArrayList<Usuario>
	List<String> listaDePasos = new ArrayList<String>
	@JsonIgnore List<Accion> listaDeAcciones = new ArrayList<Accion>
	@JsonIgnore List<CopyObserver> copyObservers= new ArrayList
	@JsonIgnore Dificultad dificultadPorAutorizar
	@JsonIgnore Receta recetaOriginal
	@JsonIgnore Accion ultimaAccion
	@JsonIgnore String pasoEliminado
	Set<Ingrediente>listaDeIngredientes  = new HashSet<Ingrediente> 
	String img = "guiso.jpg"
	
	
	def boolean caloriasAceptables(){
		
		(10 <= this.caloriasTotales && this.caloriasTotales <= 5000)
	}
	
	def boolean esValida (){
		
		!listaDePasos.empty && !totalIngredientes.empty && this.caloriasAceptables
	}

	
	def boolean esEditable (Usuario _user) {
		
		 _user == autor  || listaDeColaboradores.contains(_user) 		
	}

	def void ingresarColaborador (Usuario colaborador) {

		
		listaDeColaboradores.add(colaborador)		
	}
	
	def void removerColaborador(UsuarioColaborador nuevoColaborador){
		
		listaDeColaboradores.remove(nuevoColaborador)
	}
	
	def void ingresarPaso (String paso){
			
		listaDePasos.add(paso)		
	}
	
	def void seEliminaPaso(Integer pasoAEliminar, Accion eliminarPaso){
		
		pasoEliminado = listaDePasos.get(pasoAEliminar)
		listaDePasos.remove(listaDePasos.get(pasoAEliminar))
		ultimaAccion = eliminarPaso
	}
	
	def void seRecuperaPaso(Integer pasoAEliminar){
		
		listaDePasos.add(pasoAEliminar, pasoEliminado)
	}
	
	def void ingresarAccion(UsuarioColaborador colaborador,Accion accion){ // Se agrega accion a lista
		
		if(esColaborador(colaborador))
			listaDeAcciones.add(accion)
		else throw new Exception("No es colaborador")
	}
	
	def void realizarTodasLasAcciones(){  // Se ejecutan todas las acciones
		
		listaDeAcciones.forEach[ ejecutarAccion(this) ]
	}
	
	def void realizarAccion(Integer posicion){  // Se ejecuta una accion por individual y se elimina de la lista
		
		listaDeAcciones.get(posicion).ejecutarAccion(this)
		removerAccion(posicion)
	}
	
	def void removerAccion(Integer posicion){
		
		listaDeAcciones.remove(listaDeAcciones.get(posicion))
	}
	
	def void deshacerCambio (){  // se restablece lo modificado en la ultima Accion
		
		if (ultimaAccion !== null){
			ultimaAccion.restablecerCambio(this)
			ultimaAccion = null
			}
		else { throw new Exception("No hay acciones pendientes") }
	}
	
	def Set<Ingrediente>totalIngredientes(){}
	
	def HashSet<CondicionAlimenticia> inadecuadaPara (){}
	
	def Integer caloriasTotales()
	
	def List<String>listaTotalPasos(){}
	
	def ingresarReceta(Receta _receta){}
	
	def Dificultad dificultadCompuesta(){}
	
	
	def Boolean validaPara(Set <Alimento> alimentosDisgustados, Set<CondicionAlimenticia> condicionAlimenticia){
		
		!this.inadecuadaPara.exists(condicion | condicionAlimenticia.contains(condicion)) 
		&& !totalIngredientes.exists(ingrediente | alimentosDisgustados.contains(ingrediente.alimento)) 
		&& !this.totalIngredientes.exists(ingrediente | alimentosDisgustados.contains(ingrediente.alimento))
	}
	
	def Boolean esValidaGrupo(List<Usuario> listaUsuario){
		
		val HashSet<CondicionAlimenticia> condicionesGrupales = new HashSet<CondicionAlimenticia>
		val HashSet<Alimento> alimentosGrupales = new HashSet<Alimento>
		
		condicionesGrupales.addAll(listaUsuario.map [ usuario | usuario.condicionesAlimenticias ].flatten)
		alimentosGrupales.addAll(listaUsuario.map [ usuario | usuario.alimentosDisgustados].flatten)		
		
		return validaPara(alimentosGrupales, condicionesGrupales)
	}
	
	override boolean busqueda(String value){
		
		 coindiceNombre(value)  || coincideIngrediente(value) || coindiceAutor(value)
	}
	
	def boolean busquedaAutor(RecetaBusquedaAutor busqueda){
		val palabraBuscada = busqueda.palabraBuscada
		val autorBuscado = busqueda.nombreAutor
		
		coindiceNombre(palabraBuscada) && coindiceAutor(autorBuscado)
	}
	
	def boolean coindiceAutor(String value){
		
		autor.nombreYApellido.toLowerCase().contains(value.toLowerCase())
	}
	
	def boolean coincideIngrediente(String value){
		
		totalIngredientes.exists[ ingrediente | ingrediente.getNombre.toLowerCase.contains(value.toLowerCase)] 
	|| totalIngredientes.exists[ ingrediente | ingrediente.getNombre.toLowerCase.contains(value.toLowerCase)]
	}
	
	def boolean coindiceNombre(String value){
		
		nombreDelPlato.toLowerCase().contains(value.toLowerCase())
	}
	
	def Receta generarCopia(UsuarioAutor _usuario)
	
	def boolean esColaborador(UsuarioColaborador colaborador){
		
		listaDeColaboradores.contains(colaborador)
	}
	
	def void seEditaTitulo(String nuevoTitulo, Accion editarTitulo){  // Carga nuevo titulo para posterior aprobación
		
		ultimoNombre = nombreDelPlato
		nombreDelPlato = nuevoTitulo
		ultimaAccion = editarTitulo
	}
	
	def void seEditaDificultad(Dificultad nuevaDificultad, Accion editarDificultad){}

	
	def void seRecuperaTitulo(){
		
		nombreDelPlato = ultimoNombre
	}
	
	def void seRecuperaDificultad(){}
	
	def void sumarCopiaAutor(){
		autor.sumarCopia
	}
	
}


@JsonTypeName("recetaCompuesta")
class RecetaCompuesta extends Receta {
	@JsonProperty("type")
     private final String type = "recetaCompuesta";
	
	@Accessors List<Receta> subrecetas = new ArrayList<Receta>
	
	
	new (String _nombreDePlato, UsuarioAutor _autor){    // Constructor de Objetos
		
		setNombreDelPlato = _nombreDePlato
		
		autor = _autor			
	}
	
	new (UsuarioAutor _autor){
		
		autor = _autor
		
	}
	
	new (){
		
	}
	
	override ingresarReceta(Receta _receta){
		
		subrecetas.add(_receta)
	}
	
	override Integer caloriasTotales (){
		
		subrecetas.fold (0, [acum, receta | acum + receta.caloriasTotales])	
	}
	
	
	override inadecuadaPara (){
		val HashSet<CondicionAlimenticia> localSet = new HashSet<CondicionAlimenticia>
		
		localSet.addAll((subrecetas.map[subreceta | subreceta.inadecuadaPara].flatten))
		
		return localSet
	}
	
	override listaTotalPasos(){
		var List<String> localList = new ArrayList<String>
		localList.addAll(listaDePasos)
		localList.addAll(subrecetas.map[ subreceta | subreceta.listaTotalPasos].flatten.toList)
		return localList
	}

	
	override Set<Ingrediente> totalIngredientes(){
		subrecetas.map[ subreceta | subreceta.totalIngredientes].flatten.toSet
	}
	
	override RecetaCompuesta generarCopia(UsuarioAutor _usuario){
				
				var RecetaCompuesta copiaReceta
	           
	            copiaReceta = new RecetaCompuesta(_usuario) =>[
	            
					setNombreDelPlato = this.getNombreDelPlato
					listaDePasos = this.listaDePasos
					recetaOriginal = this        	
					subrecetas = this.subrecetas]
					
	            return copiaReceta
	}
	
	override Dificultad dificultadCompuesta(){                 
		var Set<Dificultad> dificultades = new HashSet<Dificultad>
		dificultades = subrecetas.map[subreceta | subreceta.dificultadCompuesta].toSet
		return dificultades.max()
	}	
}

@JsonTypeName("recetaSimple")
@Accessors
class RecetaSimple extends Receta{
		@JsonProperty("type")
     final String type = "recetaSimple";
	
	Integer calorias
	Dificultad dificultad
	@JsonIgnore Dificultad anteriorDificultad
	
	
	
	new (String _nombreDePlato, UsuarioAutor _autor){    
	
		setNombreDelPlato = _nombreDePlato
		
		autor = _autor		
	}
	
	new (UsuarioAutor _autor){
		
		autor = _autor
		
	}
	
	new (){
		
	}
	
	def void ingresarIngrediente (Ingrediente _ingrediente){
		
		listaDeIngredientes.add(_ingrediente)
		
	}
	
	override Integer caloriasTotales(){ calorias }
	
	override inadecuadaPara (){
		val HashSet<CondicionAlimenticia> localSet = new HashSet<CondicionAlimenticia>
		localSet.addAll(listaDeIngredientes.map [ ingrediente | ingrediente.inadecuadoPara ].flatten)
		return localSet

	}
	
	override listaTotalPasos(){ listaDePasos }
	
	override RecetaSimple generarCopia(UsuarioAutor _usuario){
				
				var RecetaSimple copiaReceta
	           
	            copiaReceta = new RecetaSimple(_usuario)=>[
	            
					setNombreDelPlato = this.getNombreDelPlato
					listaDeIngredientes = this.listaDeIngredientes
					listaDePasos = this.listaDePasos
					calorias = this.calorias
					dificultad = this.dificultad 
					recetaOriginal = this    
					]    	

	            return copiaReceta
	}
	
	override totalIngredientes(){ listaDeIngredientes }
	
	override seEditaDificultad(Dificultad nuevaDificultad, Accion editarDificultad){
		
		anteriorDificultad = dificultad
		dificultad = nuevaDificultad
		ultimaAccion = editarDificultad
	}
	
	override Dificultad dificultadCompuesta(){                 
		return dificultad
	}
	
	override seRecuperaDificultad(){
		
		dificultad = anteriorDificultad
	}
}

@Accessors
class RecetaBusquedaAutor{
	
	String palabraBuscada
	String nombreAutor
	
	new(){}
	
    new(String _palabraBuscada , String _nombreAutor){ 
    	palabraBuscada = _palabraBuscada
    	nombreAutor = _nombreAutor
    }
}
