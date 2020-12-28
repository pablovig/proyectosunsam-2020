import { Injectable } from '@angular/core';
import { Usuario } from 'src/domain/usuario';
import { Alimento } from 'src/domain/alimento';
import { GrupoAlimenticio } from 'src/domain/grupoAlimenticio';
import { Rutina } from 'src/domain/rutina';
import { IUsuarioService } from './usuario.service';
import { Celiaco, Diabetico } from 'src/domain/condicionAlimenticia';
import { cloneDeep } from 'lodash';



@Injectable({
  providedIn: 'root'
})
export class StubUsuarioService implements IUsuarioService{

  private usuarios: Usuario[]
  public usuarioLogin: Usuario
  public esListaDePreferidos:boolean

  asignadorID: number = 0

  constructor() { 
    this.usuarios = [
      this.crearUsuario("German", 67, 1.85),
      this.crearUsuario("Lucas", 77, 1.67)
  ]
  this.usuarioLogin = this.usuarioLogueado()
}

  crearUsuario(nombre:string, peso: number, estatura: number){
    const usuario = new Usuario(this.asignadorID, nombre, peso, estatura)
    this.asignadorID++

    usuario.rutina = Rutina.LEVE
    usuario.fechaDeNacimiento = new Date(2020,10,17)
    usuario.agregarCondicion(new Diabetico())
    usuario.agregarCondicion(new Celiaco())
    usuario.agregarAlimentoPreferido(new Alimento(1,"Peceto", GrupoAlimenticio.CARNES_PESCADO_HUEVO))
    usuario.agregarAlimentoPreferido(new Alimento(2,"Carne", GrupoAlimenticio.CARNES_PESCADO_HUEVO))
    return usuario
  }

  //@ts-ignore
  async getUsuario(posicion: number){ 
    this.usuarioLogin = this.usuarioLogueado() 
  }

  async modificarUsuario(usuario: Usuario){
    this.usuarios.splice(usuario.id+1, 1, usuario)
  }

  getUsuarios(){
    return this.usuarios
  }

  usuarioLogueado() : Usuario{
    return cloneDeep(this.usuarios[0])
  }

  getUsuarioByID(id:number){
    return this.usuarios.find((receta) => {
      return receta.id == id
    })
  }

  agregarAlimentoALista(alimento: Alimento){
    if(this.esListaDePreferidos){
      this.usuarioLogin.agregarAlimentoPreferido(alimento)
       
    }else{
      this.usuarioLogin.agregarAlimentoDisgustado(alimento) 
    }
  }

}
