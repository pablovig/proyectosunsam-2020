package edu.unsam.food.domain

import java.time.LocalDate
import java.util.HashSet
import java.util.List
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList
import com.fasterxml.jackson.annotation.JsonTypeInfo
import com.fasterxml.jackson.annotation.JsonSubTypes
import com.fasterxml.jackson.annotation.JsonTypeName
import com.fasterxml.jackson.annotation.JsonIgnore
import java.time.format.DateTimeFormatter
import com.fasterxml.jackson.annotation.JsonProperty
import com.fasterxml.jackson.annotation.JsonFormat
import com.fasterxml.jackson.annotation.JsonValue

@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY, property = "type")
@JsonSubTypes(
	 @JsonSubTypes.Type(value = UsuarioPorDefecto, name = "usuarioPorDefecto"),
	@JsonSubTypes.Type(value = UsuarioColaborador, name = "usuarioColaborador"),
	 @JsonSubTypes.Type(value = UsuarioAutor, name = "usuarioAutor")
)
@Accessors 
abstract class Usuario extends Entidad{

	
	String nombreYApellido
	String username
	Double peso
	Double estatura
	Rutina rutina
	@JsonIgnore LocalDate fechaDeNacimiento
	@JsonIgnore String password
	static String DATE_PATTERN = "yyyy-MM-dd"
	
	public Set<Alimento> alimentosPreferidos = new HashSet<Alimento>
	public Set<Alimento> alimentosDisgustados = new HashSet<Alimento>
	public Set <CondicionAlimenticia> condicionesAlimenticias = new HashSet<CondicionAlimenticia>
	@JsonIgnore public List<Mensaje> bandejaDeEntrada = new ArrayList<Mensaje>
  
  
	def boolean loginCorrecto(LoginUsuario busqueda)
	
	def double calcularIMC()
	
	def void establecerFecha(CharSequence _fecha)
	
	def boolean esSaludable()
	
	def void agregarAlimentoPreferido(Alimento _alimento)
	
	def void agregarAlimentoDisgustado(Alimento _alimento)
	
	def void agregarCondicionAlimenticia(CondicionAlimenticia _condicion)

	def boolean esValido()
	
	def boolean validacionNombre()
	
	def boolean validacionNoNulo()
	
	def boolean validacionHipertensoDiabetico()
		
	def boolean validacionFecha()
	
	def Receta generarCopia(Receta _receta)
	
	def Receta sugerenciaIndividual( List <Receta> listaReceta)	
		
	def sugerenciaGrupal(List<Receta> listaReceta, List<Usuario> listaUsuario){}
				
	override boolean busqueda(String value)
	
	def boolean coincideNombreOApellido(String value)
	
	def boolean coincideUser(String value)
	
	def String leerMensaje(Integer posicion)
	
	def void enviarMensaje(String mensajeAEnviar, Usuario usuarioDestino)
	
	def void ingresarMensaje(Mensaje mensaje)
	
	def boolean esAutor(){ return false }
	
	def void sumarCopia(){ }
	
	def boolean atributosSonValidos()
	
	@JsonProperty("fechaDeNacimiento")
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
	def getFechaDeNacimiento(){
		return fechaDeNacimiento
	}
	
	@JsonProperty("fechaDeNacimiento")
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
	def setFechaDeNacimiento(String _fechaNueva){
		
		if(_fechaNueva !== null)
		fechaDeNacimiento = LocalDate.parse(_fechaNueva, formatter)
	}

	def formatter() {
		DateTimeFormatter.ofPattern(DATE_PATTERN)
	}
}	

@JsonTypeName("usuarioPorDefecto")
@Accessors
class UsuarioPorDefecto extends Usuario { 
	@JsonProperty("type")
     private final String type = "usuarioPorDefecto"

	new (String _nombreYApellido, String _username, double _peso, double _estatura){
		nombreYApellido = _nombreYApellido
		username = _username
		peso = _peso
		estatura = _estatura
		
	}
	
	new (){
		
	}
	
	
	override loginCorrecto(LoginUsuario busqueda){
		return ((busqueda.username == username) && (busqueda.password == password))
	}
	
	override calcularIMC(){
		return peso / (estatura*estatura)
	}
	
	override establecerFecha(CharSequence _fecha){
				fechaDeNacimiento = LocalDate.parse(_fecha)
			}
	
	override esSaludable(){
		return (this.calcularIMC() >= 18.00 && this.calcularIMC() <=30.00 ) 
					|| condicionesAlimenticias.forall[esSaludable(this)]

	}
	
	override agregarAlimentoPreferido(Alimento _alimento){
		alimentosPreferidos.add(_alimento)
	}
	
	override agregarAlimentoDisgustado(Alimento _alimento){
		alimentosDisgustados.add(_alimento)
	}
	
	override agregarCondicionAlimenticia(CondicionAlimenticia _condicion){
		condicionesAlimenticias.add(_condicion)
	}

	override esValido(){
		validacionNombre && validacionNoNulo 
		&& validacionHipertensoDiabetico && validacionFecha
	}
	
	override validacionNombre(){
		nombreYApellido.length > 4
	}
	
	override validacionNoNulo(){
		return nombreYApellido !== null && peso != 0.0 
		&& estatura != 0.0 && fechaDeNacimiento !== null && rutina !== null
	}
	
	override validacionHipertensoDiabetico(){

		if(condicionesAlimenticias.forall[condicion | condicion.validarAlimento]){
			!alimentosPreferidos.empty
		}else {
			true
		}
	}
	
	override validacionFecha(){
		fechaDeNacimiento.isBefore(LocalDate.now.minusDays(1))
	}
	
	override generarCopia(Receta _receta){
		_receta.copyObservers.forEach[ copia | copia.copiaGenerada(_receta, this)]
		_receta.generarCopia(new UsuarioAutor(this))

	}
	
	override sugerenciaIndividual( List <Receta> listaReceta){
		return listaReceta.findFirst[ receta | receta.validaPara(alimentosDisgustados, condicionesAlimenticias)]
	}
	
		
	override sugerenciaGrupal(List<Receta> listaReceta, List<Usuario> listaUsuario) {
			
		var Receta recetaTodos
		var Set<Receta> setGrupal = new HashSet <Receta>
		
		recetaTodos = listaReceta.findFirst[receta | receta.esValidaGrupo(listaUsuario)]
		
	 	if (recetaTodos !== null){
			return recetaTodos
			
		}else{
			setGrupal.addAll(listaUsuario.map[ usuario | usuario.sugerenciaIndividual(listaReceta)])
			return setGrupal
		}
		
	}	
				
	override boolean busqueda(String value){
		coincideNombreOApellido(value) || coincideUser(value)
	}
	
	override coincideNombreOApellido(String value) {
		nombreYApellido.toLowerCase.contains(value.toLowerCase)
	}
	
	override coincideUser(String value){
		username.equalsIgnoreCase(value)
	}
	
	override leerMensaje(Integer posicion){
		
		bandejaDeEntrada.get(posicion).verMensaje
	}
	
	override enviarMensaje(String mensajeAEnviar, Usuario usuarioDestino){
		
		MailSender.instance.enviarMensaje(mensajeAEnviar, usuarioDestino, this)
	}
	
	override ingresarMensaje(Mensaje mensaje){
		
		bandejaDeEntrada.add(mensaje)
	}
	
		def entre(Double valor, Integer piso, Integer tope){
		valor > piso && valor <= tope
	}
	
	def pesoEsValido(){
		(peso !== null) && entre(peso, 0, 600)
	}
	
	def estaturaEsValida(){
		estatura !== null && entre(estatura, 0 , 3)
	}
	
	def fechaEsValida(){
		fechaDeNacimiento !== null
	}
	
	def rutinaEsValida(){
		rutina !== null
	}
	
	override atributosSonValidos(){
		this.pesoEsValido() &&
		this.estaturaEsValida() 
		this.fechaEsValida()
		&& this.rutinaEsValida
	}
}

abstract class UsuarioDecorator extends Usuario{
	
	protected Usuario usuario
	
	override calcularIMC(){ usuario.calcularIMC }
	
	override establecerFecha(CharSequence _fecha){ usuario.establecerFecha(_fecha) }
	
	override esSaludable(){ usuario.esSaludable}
	
	override agregarAlimentoPreferido(Alimento _alimento) { usuario.agregarAlimentoPreferido(_alimento) }
	
	override agregarAlimentoDisgustado(Alimento _alimento) { usuario.agregarAlimentoDisgustado(_alimento)}
	
	override agregarCondicionAlimenticia(CondicionAlimenticia _condicion){ usuario.agregarCondicionAlimenticia(_condicion) }

	override esValido(){ usuario.esValido }
	
	override validacionNombre(){ usuario.validacionNombre }
	
	override validacionNoNulo(){ usuario.validacionNoNulo }
	
	override validacionHipertensoDiabetico(){ usuario.validacionHipertensoDiabetico }
		
	override validacionFecha(){ usuario.validacionFecha }
	
	override generarCopia(Receta _receta){ usuario.generarCopia(_receta) }
	
	override sugerenciaIndividual( List <Receta> listaReceta){ usuario.sugerenciaIndividual(listaReceta) }
		
	override sugerenciaGrupal(List<Receta> listaReceta, List<Usuario> listaUsuario){ usuario.sugerenciaGrupal(listaReceta,listaUsuario) }
				
	override busqueda(String value){ usuario.busqueda(value) }
	
	override coincideNombreOApellido(String value){ usuario.coincideNombreOApellido(value) }
	
	override coincideUser(String value){ usuario.coincideUser(value) }
	
	override leerMensaje(Integer posicion){ usuario.leerMensaje(posicion) }
	
	override enviarMensaje(String mensajeAEnviar, Usuario usuarioDestino){ usuario.enviarMensaje(mensajeAEnviar, usuarioDestino) }
	
	override ingresarMensaje(Mensaje mensaje){ usuario.ingresarMensaje(mensaje)	}
	
	def entre(Double valor, Integer piso, Integer tope){
		valor > piso && valor <= tope
	}
	
	def pesoEsValido(){
		(peso !== null) && entre(peso, 0, 600)
	}
	
	def estaturaEsValida(){
		estatura !== null && entre(estatura, 0 , 3)
	}
	
	def fechaEsValida(){
		fechaDeNacimiento !== null
	}
	
	def rutinaEsValida(){
		rutina !== null
	}
	
	override atributosSonValidos(){
		this.pesoEsValido() &&
		this.estaturaEsValida() 
		this.fechaEsValida()
		&& this.rutinaEsValida
	}

}

@JsonTypeName("usuarioColaborador")
class UsuarioColaborador extends UsuarioDecorator{
		@JsonProperty("type")
     private final String type = "usuarioColaborador";
     
	new(Usuario _usuario){
		id = _usuario.id
		nombreYApellido = _usuario.nombreYApellido
		username = _usuario.username
		peso = _usuario.peso
		estatura = _usuario.estatura
		password = _usuario.password
		alimentosPreferidos = _usuario.alimentosPreferidos
		alimentosDisgustados = _usuario.alimentosDisgustados
		condicionesAlimenticias = _usuario.condicionesAlimenticias
		fechaDeNacimiento = _usuario.fechaDeNacimiento
		rutina = _usuario.rutina
	}
	
	new(){}
	
  	
	override loginCorrecto(LoginUsuario busqueda){
		return ((busqueda.username == username) && (busqueda.password == password))
	}
	
	def void solicitarCambioDeTitulo(Receta receta, String nuevoTitulo){
		
		receta.ingresarAccion(this, new EditarTitulo(nuevoTitulo))
	}
	
	def void solicitarCambioDeDificultad(Receta receta, Dificultad nuevaDificultad){
	
	receta.ingresarAccion(this, new EditarDificultad(nuevaDificultad))
	}
	
	def void solicitarAgregarColaborador(Receta receta, UsuarioColaborador nuevoColaborador){
		
		receta.ingresarAccion(this, new AgregarColaborador(nuevoColaborador))
	}
	
	def void solicitarEliminarPaso(Receta receta, Integer pasoAEliminar){
		
		receta.ingresarAccion(this, new EliminarPaso(pasoAEliminar))
	}
}

@JsonTypeName("usuarioAutor")
class UsuarioAutor extends UsuarioDecorator{
	 @JsonProperty("type")
     private final String type = "usuarioAutor";
	@Accessors int cantCopiasAutor = 0
	
	new(Usuario _usuario){
		id = _usuario.id
		nombreYApellido = _usuario.nombreYApellido
		username = _usuario.username
		peso = _usuario.peso
		estatura = _usuario.estatura
		password = _usuario.password
		alimentosPreferidos = _usuario.alimentosPreferidos
		alimentosDisgustados = _usuario.alimentosDisgustados
		condicionesAlimenticias = _usuario.condicionesAlimenticias
		fechaDeNacimiento = _usuario.fechaDeNacimiento
		rutina = _usuario.rutina
	}

	new (){
		
	}
	
  	
	override loginCorrecto(LoginUsuario busqueda){
		return ((busqueda.username == username) && (busqueda.password == password))
	}
	
	def void autorizarTodosLosCambios(Receta receta){ 
		
		receta.realizarTodasLasAcciones()
	}
	
	def void autorizarCambio(Receta receta, Integer posicion){
		
		receta.realizarAccion(posicion)
	}
	
	def void desautorizarCambio(Receta receta, Integer posicion){
		
		receta.removerAccion(posicion)
	}
	
	override esAutor(){ return true }
	
	override void sumarCopia() {
		cantCopiasAutor++
	}
	
	override generarCopia(Receta _receta){
		_receta.copyObservers.forEach[ copia | copia.copiaGenerada(_receta, this)]
		_receta.generarCopia(this)
	}
	
}

@Accessors
class LoginUsuario{
	
	String username
	String password
	
	new(){}
	
    new(String _username , String _password){ 
    	username = _username
    	password = _password
    }
}




