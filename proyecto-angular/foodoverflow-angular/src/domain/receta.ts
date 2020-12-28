import { Usuario } from './usuario'
import { Ingrediente } from './ingrediente'
import { CondicionAlimenticia } from './condicionAlimenticia'
import { Dificultad } from './dificultad'
export class Receta {

     public listaDeColaboradores: Usuario[] = []
     public listaDeIngredientes: Ingrediente[] = []
     public listaDePasos: String[] = []
     public dificultad: Dificultad

    constructor(public id?: number, public autor?: Usuario, public nombreDelPlato?: string, public calorias? :number, public img?: string, public inadecuadoPara?:String[]){   }

    static fromJson(recetaJSON: Receta): Receta {
       const resultado: Receta = Object.assign(new Receta(), recetaJSON, { autor: Usuario.fromJson(recetaJSON.autor)
        ,listaDeIngredientes: recetaJSON.listaDeIngredientes.map(ingrediente => Ingrediente.fromJson(ingrediente))
    })
    
        return resultado
      
    }

    public esAutor(usuario: Usuario): boolean{
        return this.autor.nombreYApellido == usuario.nombreYApellido
    }

    public esColaborador(usuario:Usuario): boolean{
        return this.listaDeColaboradores.some( colaborador => colaborador.nombreYApellido == usuario.nombreYApellido)
    }

    public esEditablePor(usuario:Usuario): boolean{
        return this.esAutor(usuario) || this.esColaborador(usuario)
    }

    public agregarColaborador(_colaborador: Usuario): void{
       this.listaDeColaboradores.push(_colaborador)
    }

    public agregarIngrediente(ingrediente: Ingrediente): void{
        this.listaDeIngredientes.push(ingrediente)
     }

     public agregarPaso(paso: string): void{
        this.listaDePasos.push(paso)
     }

    public inadecuadaPara(): String[]{
        let listaCondicion = this.listaDeIngredientes.map(ingrediente => ingrediente.inadecuadoPara())
        let reduce = [].concat.apply([], listaCondicion)
        return reduce   
    }

    public esValida(){
        return this.listaDePasos.length > 0 && this.listaDeIngredientes.length > 0 && this.caloriasAceptables()
    }

    public caloriasAceptables(){
		return 10 <= this.calorias && this.calorias <= 5000
	}

    toJSON(): Receta {
        return {
            type: "recetaSimple",
            ...this
        }
    }

}

export class RecetaBusquedaAutor{

    constructor(public palabraBuscada: string, public nombreAutor: string){ }
}