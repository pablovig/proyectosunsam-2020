import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { RecetaService } from 'src/app/services/receta.service';
import { UsuarioService } from 'src/app/services/usuario.service';
import { Receta, RecetaBusquedaAutor } from 'src/domain/receta';
import { Usuario } from 'src/domain/usuario';
import { mostrarError } from 'src/domain/errorMessage'

@Component({
  selector: 'app-busqueda',
  templateUrl: './busqueda.component.html',
  styleUrls: ['./busqueda.component.css']
})
export class BusquedaComponent implements OnInit {
  recetaBuscada = ''
  recetas: Receta[] = []
  isChecked: Boolean = false
  receta: Receta
  
  constructor(public recetaService : RecetaService, public usuarioService : UsuarioService, private router: Router) {  }
  
  async ngOnInit() {
    try {
      this.recetas = await this.recetaService.getRecetas()
    } catch (error) {
      mostrarError(this, error)
    }
  }

  async realizarBusqueda(): Promise<void>{

   if(!this.isChecked){
    this.recetas =  await this.recetaService.busquedaPorPalabra(this.recetaBuscada)
   }else {
     let busqueda = new RecetaBusquedaAutor(this.recetaBuscada,this.usuarioLogueado().nombreYApellido)
     this.recetas = await this.recetaService.busquedaRecetaDeUnAutor(busqueda)
   }
   
   }

   usuarioLogueado(): Usuario{
     return this.usuarioService.usuarioLogin
   }

   nuevaReceta(){
     this.recetaService.crearRecetaVacia()
     this.receta = this.recetaService.recetaEditada
     this.router.navigate(['/receta', this.receta.id]);
   }

}
