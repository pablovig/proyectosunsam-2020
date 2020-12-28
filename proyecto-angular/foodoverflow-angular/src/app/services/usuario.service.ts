import { Injectable } from '@angular/core';
import { Usuario } from 'src/domain/usuario';
import { Alimento } from 'src/domain/alimento';
import { REST_SERVER_URL } from './configuracion'
import { HttpClient } from '@angular/common/http';

export interface IUsuarioService {

  getUsuario(IDusuario): Promise<Usuario>
  modificarUsuario(usuario: Usuario): Promise<void>
  getUsuarios()
}

@Injectable({
  providedIn: 'root'
})
export class UsuarioService implements IUsuarioService{
  public usuarioLogin: Usuario
  public listaDeAlimentos: Alimento[]

  constructor(private http: HttpClient) {}

  async getUsuario(IDusuario) {
    const usuario = await this.http.post<Usuario>(REST_SERVER_URL + '/perfil', JSON.stringify(IDusuario)).toPromise()
    return this.usuarioLogin = Usuario.fromJson(usuario)
  }


  async modificarUsuario(usuario: Usuario) {
    await this.http.put(REST_SERVER_URL + '/perfil', usuario.toJSON()).toPromise()
  }
    
  async getUsuarios(){
    const usuarios = await this.http.get<Usuario[]>(REST_SERVER_URL + '/usuarios').toPromise()
    return usuarios.map((usuario) => Usuario.fromJson(usuario))
  }

  async loguearUsuario(busqueda) {
    const usuario = await this.http.post<Usuario>(REST_SERVER_URL + '/login', JSON.stringify(busqueda)).toPromise()
      this.usuarioLogin = Usuario.fromJson(usuario)
  }

  agregarAlimentoALista(alimento: Alimento){
    
    this.listaDeAlimentos.push(alimento)
    
  }
}
