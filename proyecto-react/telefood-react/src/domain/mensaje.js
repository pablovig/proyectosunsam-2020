import { format } from 'date-fns'
import * as moment from 'moment'
import { usuarioService } from '../services/usuarioService'
import { Usuario } from './usuario'
export class Mensaje {

    constructor (id = -1, cuerpoDeMensaje, destinatario = new Usuario(), emisor= new Usuario(), mensajeLeido = false, fechaDeEmision, titulo='Nuevo Mensaje' ){
        this.id = id
        this.cuerpoDeMensaje = cuerpoDeMensaje 
        this.destinatario = destinatario
        this.emisor = emisor
        this.fechaDeEmision = fechaDeEmision
        this.mensajeLeido = mensajeLeido
        this.titulo = titulo
    }


    verMensaje() {
        this.mensajeLeido = true
        return this.cuerpoDeMensaje
    }

    cambiarLeido(){
        this.mensajeLeido? this.mensajeLeido = false : this.mensajeLeido = true
    }

    esDeLectura = () => {
        return !(this.id == -1)
    }

    static fromJson(mensajeJSON) {
        const aDevolver = Object.assign(new Mensaje(),
        mensajeJSON,
          {}
          //  { destinatario: Usuario.fromJson(mensajeJSON.destinatario) }
        )
        aDevolver.destinatario = usuarioService.usuarioLogueado
        aDevolver.titulo = 'Mensaje'
        return aDevolver
    }

    toJSON() {
        return {
          ...this
        }
      }

    get fechaOrdenamiento() {
        return format(this.fechaDeEmision, 'yyyyMMdd')
      }

    get formatDate(){
      return moment(this.fechaDeEmision).format("yyyy-mm-dd")// return format(this.fechaDeEmision, 'dd/MM/yyyy')
    }

    get formatDateHour(){
        return format(this.fechaDeEmision, 'dd/MM/yyyy hh:mm')
    }
}