export class Usuario {

    mensajesRecibidos = []
    contactos = []
    
    constructor(id, nombreYApellido, username){
        this.id = id
        this.nombreYApellido = nombreYApellido
        this.username = username
    }

    agregarMail(mensaje){
        this.mensajesRecibidos.push(mensaje)
    }

    static fromJson(usuarioJSON) {
        return Object.assign(new Usuario(),
        usuarioJSON,
          { }
        )
      }
}


export class LoginUsuario {

    constructor(username, password){
        this.username = username
        this.password = password
    }

    toJSON() {
        return {
          ...this
        }
      }
}