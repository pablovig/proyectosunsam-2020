import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { AlimentoService } from 'src/app/services/alimento.service'
import { UsuarioService } from 'src/app/services/usuario.service';
import { Alimento } from 'src/domain/alimento'
import { Usuario } from 'src/domain/usuario';
import { TablaAlimentosComponent } from '../tabla-alimentos/tabla-alimentos.component';

@Component({
  selector: 'app-alimentos',
  templateUrl: './alimentos.component.html',
  styleUrls: ['./alimentos.component.css']
})
export class AlimentosComponent implements OnInit {
  
  nombreTabla: String = 'Alimento'
  alimentos: Alimento[] = []

  @ViewChild(TablaAlimentosComponent) childAlimento;

  constructor(public alimentoService: AlimentoService, public usuarioService: UsuarioService,  private router: Router, private route: ActivatedRoute) {   }


  async ngOnInit() {
    this.alimentos = await this.alimentoService.getAlimentos()
  }

  irAHome(){
    this.router.navigate(['/perfil'])
  }

  aceptar(){
    this.usuarioService.agregarAlimentoALista(this.childAlimento.alimentoSeleccionado)
    this.irAHome()
  }

  cancelar(){
    this.irAHome()
  }
}
