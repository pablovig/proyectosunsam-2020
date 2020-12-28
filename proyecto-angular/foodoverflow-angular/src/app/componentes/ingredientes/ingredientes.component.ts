import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { AlimentoService } from 'src/app/services/alimento.service'
import { RecetaService } from 'src/app/services/receta.service';
import { Alimento } from 'src/domain/alimento'
import { Ingrediente } from 'src/domain/ingrediente';
import { Receta } from 'src/domain/receta';
import { TablaAlimentosComponent } from '../tabla-alimentos/tabla-alimentos.component';


@Component({
  selector: 'app-ingredientes',
  templateUrl: './ingredientes.component.html',
  styleUrls: ['./ingredientes.component.css']
})
export class IngredientesComponent implements OnInit {

  @ViewChild(TablaAlimentosComponent) childAlimento;

  nombreTabla: String = 'Alimento'
  alimentos: Alimento[] = []
  receta: Receta = this.recetaService.recetaEditada
  cantidad: string
  errorMessage: string

  constructor(public alimentoService: AlimentoService, public router: Router, public route: ActivatedRoute, private recetaService: RecetaService ) { }

 async ngOnInit() {
    this.alimentos=  await this.alimentoService.getAlimentos()
  }

  irAReceta(){
    this.router.navigate(['/receta', this.receta.id])
  }

  aceptar(){
    if(this.childAlimento.alimentoSeleccionado && this.cantidad != null && this.noEstaEnLista()){
    this.receta.agregarIngrediente(new Ingrediente(this.childAlimento.alimentoSeleccionado, this.cantidad))
    this.irAReceta()
  } else{
    this.errorMessage = "Debe seleccionar un alimento no repetido, e introducir cantidad"
  }
  }

  noEstaEnLista(){
   if( this.receta.listaDeIngredientes.findIndex(
     ingrediente => this.childAlimento.alimentoSeleccionado.nombreDeAlimento == ingrediente.getNombre() ) == -1) {
   return true
  }else{
     return false}
  }
  cancelar(){
    this.irAReceta()
  }
}

