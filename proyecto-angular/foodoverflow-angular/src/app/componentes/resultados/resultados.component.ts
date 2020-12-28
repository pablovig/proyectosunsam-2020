import { Component, Input, OnInit } from '@angular/core';
import { Receta } from 'src/domain/receta';

@Component({
  selector: 'app-resultados',
  templateUrl: './resultados.component.html',
  styleUrls: ['./resultados.component.css']
})
export class ResultadosComponent implements OnInit {

  @Input() recetas: Receta[]

  constructor() { }

  ngOnInit(): void {
  }
  
  eliminarReceta(receta: Receta) {
    this.recetas.splice(this.recetas.indexOf(receta), 1)
  }
}
