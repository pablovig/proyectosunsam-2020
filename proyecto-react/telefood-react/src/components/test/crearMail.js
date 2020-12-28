import { Mensaje } from '../../domain/mensaje'

export function crearMail(id, cuerpoDeMensaje, destinatario, emisor, fechaDeEmision, mensajeLeido) {
    return Object.assign(new Mensaje(), {
        id,
        cuerpoDeMensaje,
        destinatario,
        emisor,
        fechaDeEmision,
        mensajeLeido
    })
}
