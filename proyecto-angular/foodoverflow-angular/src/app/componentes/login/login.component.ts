import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { UsuarioService } from 'src/app/services/usuario.service';
import { LoginUsuario } from 'src/domain/usuario';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  constructor(public usuarioService : UsuarioService, private router: Router) { }
  
  errorMessage:string
  username: string
  password: string

  ngOnInit() {
    
  }

  async login(){
    try{
      await this.usuarioService.loguearUsuario(new LoginUsuario(this.username, this.password))
      this.router.navigate(['/busqueda'])
      
    } catch(error){
      this.errorMessage = error.error
    }
  }
}



 