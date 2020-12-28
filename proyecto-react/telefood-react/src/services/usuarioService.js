import axios from 'axios'
import { Busqueda } from '../domain/busqueda';
import { Mensaje } from "../domain/mensaje";
import { Usuario, LoginUsuario } from "../domain/usuario";
import { REST_SERVER_URL } from './configuration'


class UsuarioService{
    
    usuarioLogueado = null

    usuarioAJson(usuarioJSON) {
        return Usuario.fromJson(usuarioJSON)
    }
    
    async loguearUsuario(login){
        const usuarioJson = await axios.post(`${REST_SERVER_URL}/login`, login.toJSON())
        this.usuarioLogueado = this.usuarioAJson(usuarioJson.data)      
    }


    async getUsuarios(palabraBuscada){
         const palabra = new Busqueda(palabraBuscada)
         const usuariosJSON = await axios.post(`${REST_SERVER_URL}/busquedausuarios`, palabra.toJSON())
         return usuariosJSON.data.map((usuariosJSON) => Usuario.fromJson(usuariosJSON)) 
    }

    async getUsuarioByID(id){
        const usuarioJson = await axios.get(`${REST_SERVER_URL}/usuario/${id}`)
        return Usuario.fromJson(usuarioJson.data)     
    }


    getUsuariosSinLogueado(usuarios){
        let index = usuarios.findIndex(usuario => usuario.id == usuarioService.usuarioLogueado.id)
        if (index!=-1){
        usuarios.splice(index, 1)
        }
        return usuarios
    }

}

export const usuarioService = new UsuarioService()