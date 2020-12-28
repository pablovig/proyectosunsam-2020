import { Component, OnInit } from '@angular/core'
import { Router } from '@angular/router'
import { CondicionService } from 'src/app/services/condicion.service'
import { RecetaService } from 'src/app/services/receta.service'
import { UsuarioService } from 'src/app/services/usuario.service'
import { CondicionAlimenticia } from 'src/domain/condicionAlimenticia'
import { Receta, RecetaBusquedaAutor } from 'src/domain/receta'
import { Rutina } from 'src/domain/rutina'
import { Usuario } from 'src/domain/usuario'
import { mostrarError } from 'src/domain/errorMessage'

@Component({
  selector: 'app-perfil',
  templateUrl: './perfil.component.html',
  styleUrls: ['./perfil.component.css']
})
export class PerfilComponent implements OnInit {

  usuarioPerfil: Usuario 
  recetasDeUsuario: Receta[]
  condiciones: CondicionAlimenticia[] = []
  rutinas = Rutina
  listaDeRutinas = []
  errorMessage: string

  constructor(public usuarioService: UsuarioService,
     public condicionesService: CondicionService,
      public recetaService: RecetaService,
       private router: Router ) {}


  async ngOnInit() { 
    try{
      await this.inicializacionDeUsuario()
    } catch (error) {
      mostrarError(this, error)
    }
  }

  async inicializacionDeUsuario(){

    await this.ruteoDeUsuario()
    this.condiciones = this.condicionesService.getCondiciones()
    this.listaDeRutinas = Object.keys(this.rutinas)
    await this.getRecetasDeUsuario()
    console.log(this.usuarioPerfil)
  }

   async ruteoDeUsuario(){

    this.usuarioPerfil = this.usuarioService.usuarioLogin
    this.condicionesService.crearCondicionesdeUsuario(this.usuarioService.usuarioLogin, this.usuarioPerfil)
  }


  irAHome(){
    this.router.navigate(['/busqueda'])
  }

  async aceptar(){
    if (this.usuarioPerfil.esValido()){
      await this.usuarioService.modificarUsuario(this.usuarioPerfil)
      this.irAHome()
    } else {
      this.errorMessage = "Campo incompleto o valor incorrecto"
    }
    
  }

  async cancelar(){
    await this.usuarioService.getUsuario(this.usuarioPerfil.id)
    this.irAHome()
  }

  esSaludableTexto(){   
    if (this.usuarioPerfil.esSaludable()) return "Estado Saludable"
    else return "Estado No Saludable"
  }

  eliminarReceta(receta: Receta) {
    this.recetasDeUsuario.splice(this.recetasDeUsuario.indexOf(receta), 1)
  }

  modificarCondicion(condicion: CondicionAlimenticia) {
    if (!(this.tieneCondicion(condicion))) {
      this.usuarioPerfil.agregarCondicion(condicion)
    }    
    else this.usuarioPerfil.quitarCondicion(condicion)
  }

  tieneCondicion(condicion: CondicionAlimenticia): boolean {
     
    return this.usuarioPerfil.tieneCondicion(condicion)
  }

  async getRecetasDeUsuario(){
    let busqueda = new RecetaBusquedaAutor("",this.usuarioPerfil.nombreYApellido)
     this.recetasDeUsuario = await this.recetaService.busquedaRecetaDeUnAutor(busqueda)
  }
}
