import { render, fireEvent, screen  } from '@testing-library/react'
import React from 'react'
import { Mensaje } from '../../domain/mensaje.js'
import { MensajeTextBox } from '../MensajeTextBox.js'
import { BotonesTextBox } from '../MensajeTextBox.js'
import { Usuario } from '../../domain/usuario.js'
import { crearUsuario } from './crearUsuario'

const usuarioDestino = crearUsuario(1,"Edu","edu")
const usuarioEmisor = crearUsuario(2,"Lucas", "lucas")
const mailDeLectura = new Mensaje(1,"Que onda padre TRUE", usuarioDestino, new Usuario(40,"Jorge True", "jorge14"), new Date(), true)
const mailParaEnviar = new Mensaje(-1,"Cómo estás?", usuarioEmisor, usuarioDestino)
const mailNuevo = new Mensaje(-1,null)




describe('MensajeTextBox', () => {
    describe('Cuando se recibe un mail de lectura', () => {
        test('Se verifica que el contenido del mensaje se encuentra renderizado', async () => {
            render( <MensajeTextBox 
            mail={mailDeLectura} 
            usuario={usuarioEmisor}/> )
            expect(screen.getByText(/Que onda padre TRUE/)).toBeInTheDocument()
        })

        test('Se muestra que el botón volver se enucentra renderizado', async () => {
            const { queryByTestId } = render( <MensajeTextBox 
            mail={mailDeLectura} 
            usuario={usuarioEmisor}/> )
            //Para verificar que es de lectura se busca que aparezca el contenido del mensaje renderizado
            expect(queryByTestId("botonVolver")).toBeInTheDocument()
            expect(queryByTestId("botonesEnEscritura")).toBeNull()
        })

        test('Se hace click en el botón volver y se redirecciona a /contactos', async () => {
            const pushStub = jest.fn()
            const ejecutarBotonVolver = () => { pushStub('/contactos') }
            const { getByTestId } = render( <BotonesTextBox 
                mensajeLectura={true} 
                ejecutarBotonVolver={() => ejecutarBotonVolver()}
            /> )
            
            expect(fireEvent.click(getByTestId('botonVolver')))
            expect(pushStub).toBeCalledWith(`/contactos`)
            
        })
    })

    describe('Cuando se recibe un mail de escritura', () => {
        test('Se verifica que el contenido del mensaje no se encuentra renderizado', async () => {
            render( <MensajeTextBox 
            mail={mailNuevo} 
            usuario={usuarioDestino}/> )
            expect(screen.queryByText(/Que onda padre TRUE/)).toBeNull()
        })

        test('Se muestra que el div que contiene los botones de Cancelar y Aceptar se enucentra renderizado',
         async () => {
            const { queryByTestId } = render( <MensajeTextBox 
            mail={mailNuevo} 
            usuario={usuarioDestino}/> )
            //Para verificar que es de lectura se busca que aparezca el contenido del mensaje renderizado
            expect(queryByTestId("botonesEnEscritura")).toBeInTheDocument()
            expect(queryByTestId("botonVolver")).toBeNull()
        })

        test('Se hace click en el botón Cancelar y Aceptar y se verifica que redireccionan a /contactos', async () => {
            const pushStubCancelar = jest.fn()
            const pushStubAceptar = jest.fn()
            const ejecutarBotonCancelar = () => { pushStubCancelar('/contactos') }
            const ejecutarBotonAceptar = () => { pushStubAceptar('/contactos') }
            const { getByTestId } = render( <BotonesTextBox 
                mensajeLectura={false} 
                ejecutarCancelarEnvio={() => ejecutarBotonCancelar()}
                ejecutarAceptarEnvio={() => ejecutarBotonAceptar()}
            /> )
            
            expect(fireEvent.click(getByTestId('botonCancelar')))
            expect(pushStubCancelar).toBeCalledWith(`/contactos`)

            expect(fireEvent.click(getByTestId('botonAceptar')))
            expect(pushStubAceptar).toBeCalledWith(`/contactos`)
            
        })
    })
})