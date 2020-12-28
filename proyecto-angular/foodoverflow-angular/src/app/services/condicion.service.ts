import { Injectable } from '@angular/core';
import { Celiaco, CondicionAlimenticia, Diabetico, Hipertenso, Vegano, Vegetariano } from 'src/domain/condicionAlimenticia';
import { HttpClient } from '@angular/common/http'
import { REST_SERVER_URL } from './configuracion'
@Injectable({
  providedIn: 'root'
})
export class CondicionService {

  private condicionesAlimenticias: CondicionAlimenticia[] = []

  constructor() { 
    this.condicionesAlimenticias = [
      new Diabetico(),
      new Celiaco(),
      new Vegano(),
      new Vegetariano(),
      new Hipertenso()
   ]
  }

  getCondiciones(): CondicionAlimenticia[] {
    return this.condicionesAlimenticias
  }

  getCondicion(posicion: number): CondicionAlimenticia{
    return this.condicionesAlimenticias[posicion]
  }

  public crearCondicionesdeUsuario(usuarioJSON, usuarioLogueado){

    let condicionesNueva: any[] = []

     usuarioJSON.condicionesAlimenticias.forEach(
      condicion => condicionesNueva.push(this.condicionesAlimenticias
      .find(condicionAlimenticia => condicionAlimenticia.nombre == condicion.nombre).crearCondicion())
      )
      usuarioLogueado.condicionesAlimenticias = []
      usuarioLogueado.condicionesAlimenticias = condicionesNueva
  }
}
