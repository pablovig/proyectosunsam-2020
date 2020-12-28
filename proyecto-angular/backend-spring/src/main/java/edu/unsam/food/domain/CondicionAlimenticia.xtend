package edu.unsam.food.domain


import org.eclipse.xtend.lib.annotations.Accessors

import com.fasterxml.jackson.annotation.JsonTypeInfo
import com.fasterxml.jackson.annotation.JsonSubTypes
import com.fasterxml.jackson.annotation.JsonTypeName

@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY, property = "type")
@JsonSubTypes( 
	@JsonSubTypes.Type(value = Diabetico, name = "diabetico"),
	@JsonSubTypes.Type(value = Celiaco, name = "celiaco"),
	@JsonSubTypes.Type(value = Hipertenso, name = "hipertenso"),
	@JsonSubTypes.Type(value = Vegano, name = "vegano"),
	@JsonSubTypes.Type(value = Vegetariano, name = "vegetariano")
)
@Accessors
abstract class CondicionAlimenticia{
	String nombre
	
	def boolean esSaludable(UsuarioPorDefecto usuario)
	
	def boolean validarAlimento(){
		false
	}
}


@Accessors
@JsonTypeName("diabetico")
class Diabetico extends CondicionAlimenticia{
	
	String nombre = "Diabetico"
	
	override esSaludable(UsuarioPorDefecto usuario){
		return   usuario.peso < 70 || usuario.rutina == Rutina.ACTIVO
	}
	
	override validarAlimento(){
		true
	}
}

@Accessors
@JsonTypeName("celiaco")
class Celiaco extends CondicionAlimenticia{
	String nombre = "Celiaco"
	
	override esSaludable(UsuarioPorDefecto usuario){
		true
	}
	
}

@Accessors
@JsonTypeName("hipertenso")
class Hipertenso extends CondicionAlimenticia{
	String nombre = "Hipertenso"
	
	override esSaludable(UsuarioPorDefecto usuario){
		return usuario.rutina == Rutina.INTENSIVO
	}
	
	override validarAlimento(){
		true
	}
}

@Accessors
@JsonTypeName("vegano")
class Vegano extends CondicionAlimenticia{
	String nombre = "Vegano"
	override esSaludable(UsuarioPorDefecto usuario){
		return usuario.alimentosPreferidos.filter[alimento | alimento.grupoAlimenticio == GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS].size()== 2
	}
}

@Accessors
@JsonTypeName("vegetariano")
class Vegetariano extends CondicionAlimenticia{
	String nombre = "Vegetariano"
	override esSaludable(UsuarioPorDefecto usuario){
		if (usuario.calcularIMC<30){
			return true
		}else 
		
		return !usuario.alimentosPreferidos.exists(alimento | alimento.grupoAlimenticio == GrupoAlimenticio.ACEITES_GRASAS_AZUCARES)
	}
	
}
