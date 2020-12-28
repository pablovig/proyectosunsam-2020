import { Component, Input, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { RecetaService } from 'src/app/services/receta.service';
import { Ingrediente } from 'src/domain/ingrediente';
import { Receta } from 'src/domain/receta';
import { Usuario } from 'src/domain/usuario';
import { Dificultad } from 'src/domain/dificultad'
import { RoutingService } from 'src/app/services/routing.service';
import { mostrarError } from 'src/domain/errorMessage'
import { UsuarioService } from 'src/app/services/usuario.service';

@Component({
  selector: 'app-receta',
  templateUrl: './receta.component.html',
  styleUrls: ['./receta.component.css']
})
export class RecetaComponent implements OnInit {

  receta: Receta
  dificultades = Dificultad
  enumDificultades = []
  usuarioLogin = this.usuarioService.usuarioLogin
  errors = []
  errorMessage : string

  constructor(private usuarioService: UsuarioService, private recetaService: RecetaService, private router: Router, private route: ActivatedRoute, private routingService: RoutingService) { }


  async ngOnInit() {
    try {
      await this.observableRouting()
      this.enumDificultades = Object.values(this.dificultades)
    } catch (error) {
      mostrarError(this, error)
    }
  }

  async observableRouting(){
    const idReceta = this.route.snapshot.params['id']
    idReceta > 0? await this.ruteoRecetaExistente(idReceta): this.ruteoNuevaReceta()    
  }

  ruteoNuevaReceta(){
    if(!this.recetaService.recetaEditada){
      this.recetaService.crearRecetaVacia()
      this.receta = this.recetaService.recetaEditada
    }else{
      this.receta = this.recetaService.recetaEditada
    }
  }

  async ruteoRecetaExistente(idReceta){
    if(!this.recetaService.recetaEditada){
      this.receta = await this.recetaService.getRecetaByID(idReceta)
      this.recetaService.recetaEditada = this.receta
    }else {
      this.receta = this.recetaService.recetaEditada
    }
  }

  irAHome(){
    this.recetaService.recetaEditada = null
    this.router.navigate([this.routingService.rutaAnteriorEstricta.value])
  }

  async aceptar(){
    try {
      if(this.receta.esValida()){
        this.receta.id > 0? await this.aceptarModificacion() : await this.aceptarNueva()
        this.irAHome()
      }else{
        this.errorMessage = "Debe llenar al menos un paso, un ingrediente, y calorias entre 10 y 5000"
      }
    } catch (e) {
      this.errors.push(e.error)
    }
  }

  async aceptarNueva(){
      await this.recetaService.agregarReceta(this.receta)
  }

  async aceptarModificacion(){
    await this.recetaService.modificarReceta(this.receta)
  }

  cancelar(){
    this.irAHome()
  }

  agregarIngrediente(){
    this.router.navigate(['/ingrediente']);
  }
  
  agregarColaborador(){
    this.router.navigate(['/colaborador'])
  }

  agregarPaso(){
    this.router.navigate(['/pasos'])
  }

  eliminarPaso(paso: string){
    this.receta.listaDePasos.splice(this.receta.listaDePasos.indexOf(paso), 1)  
  }

  eliminarIngrediente(ingrediente: Ingrediente){
    this.receta.listaDeIngredientes.splice(this.receta.listaDeIngredientes.indexOf(ingrediente), 1)
  }

  eliminarColaborador(colaborador: Usuario){
    this.receta.listaDeColaboradores.splice(this.receta.listaDeColaboradores.indexOf(colaborador), 1)
  }

}
