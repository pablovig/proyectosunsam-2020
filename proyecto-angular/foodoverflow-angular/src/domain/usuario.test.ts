import { Vegano, Diabetico, Vegetariano, Hipertenso, Celiaco } from './condicionAlimenticia'
import { Rutina } from './rutina'
import { GrupoAlimenticio } from './grupoAlimenticio'
import { Usuario } from './usuario'
import { Alimento } from './alimento'

describe('Tests de Usuario', () => {

    let usuarioSinCondicion: Usuario
    let usuarioConCondicion: Usuario
    let usuarioAltoImc: Usuario

    beforeEach(() => {
        usuarioSinCondicion = new Usuario ('Pedro', 97.2, 1.8)
        usuarioConCondicion = new Usuario('Juan', 97.2, 1.8)
        usuarioAltoImc = new Usuario("Jorge Zarate", 110, 1.5)
    })
    
    test('Test que prueba la medicion de IMC de un Usuario sin condiciones', () => {

        expect(usuarioSinCondicion.calculoIMC()).toBe(30)
    })

    test('Test que prueba que un usuario sin condiciones es saludable cumpliendo su IMC', () => {

        expect(usuarioSinCondicion.esSaludable()).toBeTruthy()
    })

    test('Test que prueba que un usuario con condicion de Diabetico es saludable porque cumple su rutina de ACTIVO',() => {
        
        usuarioConCondicion.agregarCondicion(new Diabetico)
        usuarioConCondicion.rutina=Rutina.ACTIVO

        expect(usuarioConCondicion.esSaludable()).toBeTruthy()
    })

    test('Test que prueba que un usuario con condicion de Diabetico no es saludable porque no cumple con el peso ni con la rutina',()=>{
    
        usuarioConCondicion.agregarCondicion(new Diabetico)
        usuarioConCondicion.rutina=Rutina.NADA

        expect(usuarioConCondicion.esSaludable()).toBeFalsy()
    })

    test('Test que prueba que un usuario con condicion de Vegano es saludable porque tiene dos alimentos preferidos del grupo 5. ', ()=>{
        
        usuarioConCondicion.agregarCondicion(new Vegano)
        usuarioConCondicion.agregarAlimentoPreferido(new Alimento("Pera",GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS))
        usuarioConCondicion.agregarAlimentoPreferido(new Alimento("Menzana",GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS))

        expect(usuarioConCondicion.esSaludable()).toBeTruthy()
    })

    test('Test que prueba que un usuario con condición de Vegano no es saludable porque no tiene al menos dos alimentos preferidos de grupo 5', ()=>{
        
        usuarioConCondicion.agregarCondicion(new Vegano)
        usuarioConCondicion.agregarAlimentoPreferido(new Alimento("Pera",GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS))
        
        expect(usuarioConCondicion.esSaludable()).toBeFalsy()
    })

    test('Test que prueba que un usuario con condicion de Vegetariano es saludable porque no tiene Grasa entre favoritos y cumple IMC',()=>{
       
        usuarioConCondicion.agregarCondicion(new Vegetariano)
        usuarioConCondicion.agregarAlimentoPreferido(new Alimento("Manzana",GrupoAlimenticio.HORTALIZAS_FRUTAS_SEMILLAS))
        
        expect(usuarioConCondicion.esSaludable()).toBeTruthy()
    })


    test('Test que prueba que un usuario con condicion de Vegetariano no es saludable porque tiene como alimento favorito Grasas',()=>{
       
        usuarioConCondicion.agregarCondicion(new Vegetariano)
        usuarioConCondicion.agregarAlimentoPreferido(new Alimento("Bizcocho de Grasa",GrupoAlimenticio.ACEITES_GRASAS_AZUCARES))
        
        expect(usuarioConCondicion.esSaludable()).toBeFalsy()
    })

    test('Test que prueba que un usuario con condicion de Hipertenso es saludable porque tiene de Rutina INTENSIVO.', ()=>{
        
        usuarioConCondicion.agregarCondicion(new Hipertenso)
        usuarioConCondicion.rutina=Rutina.INTENSIVO

        expect(usuarioConCondicion.esSaludable()).toBeTruthy()
    })

    test('Test que prueba que un usuario con condicion de Hipertenso no es saludable porque no tiene de Rutina INTENSIVO.', ()=>{
        
        usuarioConCondicion.agregarCondicion(new Hipertenso)
        usuarioConCondicion.rutina=Rutina.MEDIANO

        expect(usuarioConCondicion.esSaludable()).toBeFalsy()
    })


})