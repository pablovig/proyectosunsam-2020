import { Usuario } from '../../domain/usuario'

export function crearUsuario(id, nombreYApellido, username) {
    return Object.assign(new Usuario(), {
        id,
        nombreYApellido,
        username,
    })
}