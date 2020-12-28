import { CondicionAlimenticia, Vegano, Celiaco } from './condicionAlimenticia'
import { Rutina } from './rutina'
import { GrupoAlimenticio } from './grupoAlimenticio'
import { Usuario } from './usuario'
import { Alimento } from './alimento'
import { Receta } from './receta'
import { Ingrediente } from './ingrediente'

describe('Conjunto de Tests', () => {

    let usuarioAutor: Usuario
    let usuarioColaborador: Usuario
    let usuarioNoColaborador:Usuario
    let receta1: Receta
    let milanesa: Alimento
    let papa: Alimento
    let ingrediente1: Ingrediente
    let ingrediente2: Ingrediente
    let condicionVegano: CondicionAlimenticia
    let condicionCeliaco: CondicionAlimenticia

    beforeEach(() => {
        usuarioAutor = new Usuario("Pedro", 80, 1.80)
        usuarioColaborador = new Usuario("Jose", 75, 1.70)
        receta1 = new Receta(usuarioAutor, "Milanesa con papas fritas")
        milanesa = new Alimento("Milanesa", GrupoAlimenticio.CARNES_PESCADO_HUEVO)
        papa = new Alimento("Papa", GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS)
        ingrediente1 = new Ingrediente(milanesa, 500)
        ingrediente2 = new Ingrediente(papa, 400)
        condicionVegano = new Vegano()
        condicionCeliaco = new Celiaco()

    })

    test('Test que prueba que una receta es editable por usuarioAutor, autor de la receta ', () => {
        usuarioNoColaborador = new Usuario("Miguel", 72, 1.78)

        expect(receta1.esEditablePor(usuarioAutor)).toBeTruthy()
        expect(receta1.esEditablePor(usuarioNoColaborador)).toBeFalsy()
    })

    test('Test que prueba que una receta es editable por usuarioColaborador, colaborador de la receta', () => {
        receta1.agregarColaborador(usuarioColaborador)
        expect(receta1.esEditablePor(usuarioColaborador)).toBeTruthy()
    })

    test('Test que prueba que una receta es inadecuada porque dos de sus ingredientes son inadecuados. ', () => {
        ingrediente1.agregarInadecuado(condicionVegano)
        ingrediente2.agregarInadecuado(condicionCeliaco)
        receta1.agregarIngrediente(ingrediente1)
        receta1.agregarIngrediente(ingrediente2)

        expect(receta1.inadecuadoPara()).toContain(condicionVegano)
        expect(receta1.inadecuadoPara()).toContain(condicionCeliaco)
    })
    


})