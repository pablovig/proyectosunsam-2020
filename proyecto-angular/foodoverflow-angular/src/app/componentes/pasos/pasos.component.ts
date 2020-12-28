import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { RecetaService } from 'src/app/services/receta.service';
import { UsuarioService } from 'src/app/services/usuario.service';
import { Receta } from 'src/domain/receta';

@Component({
  selector: 'app-pasos',
  templateUrl: './pasos.component.html',
  styleUrls: ['./pasos.component.css']
})
export class PasosComponent implements OnInit {

  receta: Receta = this.recetaService.recetaEditada
  unPaso: string
  pasos: string[] = []
  seleccionado: string

  constructor(private recetaService: RecetaService, private router: Router) { }

  ngOnInit(): void {
  }
  aceptar(){
      this.pasos.forEach(paso => this.receta.agregarPaso(paso))
      this.irAReceta()
  }

  cancelar(){
    this.irAReceta()
  }

  irAReceta(){
    this.router.navigate(['/receta', this.receta.id])
  }

  seleccion(paso:string){
    this.seleccionado = paso
  }

  agregarPaso(){
    if(this.unPaso != ""){
      this.pasos.push(this.unPaso)
    }
    this.unPaso= ""
  }
  
  borrarPaso(){
    this.pasos.splice(this.pasos.indexOf(this.seleccionado),1)
  }
  


}
