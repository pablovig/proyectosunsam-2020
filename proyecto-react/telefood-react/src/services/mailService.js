import { Mensaje } from "../domain/mensaje";
import { usuarioService } from "./usuarioService";
import axios from 'axios'
import { REST_SERVER_URL } from './configuration'
import { Busqueda } from '../domain/busqueda';


class MailService{
    
    getUsuarioLogueado(){
        return usuarioService.usuarioLogueado
    }

    async cambiarEstadoLeido(id){
        return axios.put(`${REST_SERVER_URL}/cambiarleido/${id}`)
    }

    async delete(id){
        return axios.delete(`${REST_SERVER_URL}/mensaje/${id}`)
    }

    async getMails(palabraBuscada){
        const palabra = new Busqueda(palabraBuscada)
        const mailsJSON = await axios.post(`${REST_SERVER_URL}/mensajesdeusuario/${usuarioService.usuarioLogueado.id}`, palabra.toJSON())
        return mailsJSON.data.map((mailsJSON) => Mensaje.fromJson(mailsJSON))
    }
       
    async getMailDeUsuario(mensajeID){
        const mailJson = await axios.get(`${REST_SERVER_URL}/mensajes/${mensajeID}`)
        return Mensaje.fromJson(mailJson.data)
    }

    async getNuevoMail(usuarioID){
        const nuevoMail = new Mensaje()
        nuevoMail.destinatario = await usuarioService.getUsuarioByID(usuarioID)
        nuevoMail.emisor = usuarioService.usuarioLogueado
        return nuevoMail
    }

    async sendMail(mail){
        const mensaje = new Busqueda(mail.cuerpoDeMensaje)
        axios.put(`${REST_SERVER_URL}/mensajes/send/${mail.emisor.id}/${mail.destinatario.id}`, mensaje.toJSON())
    }
}

export const mailService = new MailService()