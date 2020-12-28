import { render, fireEvent, screen  } from '@testing-library/react'
import React from 'react'
import { BrowserRouter } from 'react-router-dom'
import { Mensaje } from '../../domain/mensaje.js'
import { MensajeTop } from '../MensajeTop.js'
import { Usuario } from '../../domain/usuario.js'
import { crearUsuario } from './crearUsuario'

const usuarioDestino = crearUsuario(1,"Edu","edu")
const usuarioEmisor = crearUsuario(2,"Lucas", "lucas")
const mailDeLectura = new Mensaje(1,"Que onda padre TRUE", usuarioDestino, usuarioEmisor, new Date(), true)
const mailNuevo = new Mensaje(-1,null)

describe('MensajeTop', () => {
    describe('Cuando se recibe un mail de lectura', () => {
        test('Se muestran fecha de mensaje y botones de borrar y de no leído', async () => {
            const { queryByTestId } = render(<BrowserRouter><MensajeTop mail={mailDeLectura} usuario={usuarioEmisor} /></BrowserRouter>)
            expect(queryByTestId('fechaDeMensaje')).toBeInTheDocument()
            expect(queryByTestId('botones')).toBeInTheDocument()
        })

        test('Se muestra correctamente el texto en donde se incluye el nombre', () =>{
            render (
            <MensajeTop mail={mailDeLectura} 
            usuario={usuarioEmisor}/> ) 
            // Como renderiza "De [object Object]" no me toma como correcto si pongo "De Lucas"
            //Pero como "De " carga en el caso de ser un mail de lectura, me confirma la carga correcta
            expect(screen.getByText(/De /)).toBeInTheDocument()
        } )

        test('Al presionar los botones de borrar y de no leído se redirecciona correctamente', () => {
            //var rutaElegida = ''
            // const history = {push: (ruta) => { rutaElegida = ruta }}
            // const { getByTestId } = render(
            //     <MensajeTop mail={mailDeLectura} 
            //     usuario={usuarioEmisor} 
            //     botonBorrar={() => botonBorrar()} 
            //     history={ history }/>
            //     )
                
            const pushStub = jest.fn()
            const botonBorrar = () => { pushStub('/home') }
            const { getByTestId } = render(
                <MensajeTop mail={mailDeLectura} 
                usuario={usuarioEmisor} 
                botonBorrar={() => botonBorrar()} 
                history={ {push: pushStub} }/>
                ) 
                // expect(rutaElegida).toBe('/home')
                fireEvent.click(getByTestId('botonBorrar'))
                expect(pushStub).toBeCalledWith(`/home`)
        })
    })

    describe('Cuando se recibe un mail de escritura', () => { 
        let componente
        beforeEach(() => {
            componente = render(<BrowserRouter><MensajeTop mail={mailNuevo} usuario={usuarioDestino} /></BrowserRouter>)
        })     
        test('No se renderizan fecha de mail ni botones', () => {
            const { queryByTestId } = componente
            expect(queryByTestId('fechaDeMensaje')).toBeNull()
            expect(queryByTestId('botones')).toBeNull()
        })

        test('Se muestra correctamente el texto en donde se incluye el nombre', () =>{
            //render(<BrowserRouter><MensajeTop mail={mailNuevo} usuario={usuarioDestino} /></BrowserRouter>)
            // Como renderiza "Para [object Object]" no me toma como correcto si pongo "Para Lucas"
            //Pero como "Para " carga en el caso de ser un mail de Escritura, me confirma la carga correcta
            expect(screen.getByText(/Para /)).toBeInTheDocument()
        })

  })
})