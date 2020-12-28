import { Component, Input, OnInit } from '@angular/core'
import { Router } from '@angular/router'
import { UsuarioService } from 'src/app/services/usuario.service'
import { Alimento } from 'src/domain/alimento'

@Component({
  selector: 'app-alimentosperfil',
  templateUrl: './alimentosperfil.component.html',
  styleUrls: ['./alimentosperfil.component.css']
})
export class AlimentosperfilComponent implements OnInit {
 
  @Input() titulo: string
  @Input() listaDeAlimentos: Alimento[]

  constructor(public router: Router, public usuarioService: UsuarioService) {}

  ngOnInit() {}

  goToAlimento(){
    this.usuarioService.listaDeAlimentos = this.listaDeAlimentos
    this.router.navigate(['/alimento'])
  }

  eliminarAlimento(alimento: Alimento){
    this.listaDeAlimentos.splice(this.listaDeAlimentos.indexOf(alimento),1) 
  }
}
