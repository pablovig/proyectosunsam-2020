import { CondicionAlimenticia } from './condicionAlimenticia'
import { Alimento } from './alimento'

export class Ingrediente {

    static fromJson(ingredienteJSON): Ingrediente {
        return Object.assign(new Ingrediente(), ingredienteJSON, { alimento: Alimento.fromJson(ingredienteJSON.alimento)})
    }

    constructor(public alimento?: Alimento, public cantidad?: string ){}

    getNombre = (): string => this.alimento.nombreDeAlimento

    inadecuadoPara = (): CondicionAlimenticia[] => this.alimento.inadecuadoPara

    agregarInadecuado = (condicion: CondicionAlimenticia) => this.alimento.agregarInadecuado(condicion)

    
}