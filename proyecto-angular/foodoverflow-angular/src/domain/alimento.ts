import { Celiaco, CondicionAlimenticia, Diabetico, Hipertenso, Vegano, Vegetariano } from './condicionAlimenticia';
import { GrupoAlimenticio } from './grupoAlimenticio';
import { Ingrediente } from './ingrediente';
import { CondicionService } from 'src/app/services/condicion.service'

export class Alimento {
  
  constructor(public id?: number,public nombreDeAlimento?: string, public grupoAlimenticio?: GrupoAlimenticio, public inadecuadoPara?: CondicionAlimenticia[] ) {}

   static fromJson(alimentoJSON): Alimento {
    return Object.assign(new Alimento(), alimentoJSON)}

  agregarInadecuado = (condicion: CondicionAlimenticia) =>
    this.inadecuadoPara.push(condicion)
}
