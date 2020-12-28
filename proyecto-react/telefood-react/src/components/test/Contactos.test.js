import { fireEvent, render, waitFor } from '@testing-library/react'
import React from 'react'
import { crearUsuario } from './crearUsuario'
import { usuarioService } from '../../services/usuarioService'
import { Contactos } from '../Contactos.js'
import { BrowserRouter } from 'react-router-dom'
import { createMemoryHistory } from 'history'
import userEvent from '@testing-library/user-event'
import { screen } from '@testing-library/dom'

const mockUsuario =  [
    crearUsuario(240, 'Raul', 'Raulito96'),
    crearUsuario(420, 'Pedro', 'Pedrito')
]

const mockUsuarioVacio =  [
]
  
describe('ContactosComponent', () => {
  describe('Se envia lista de contactos y se muestra correctamente.', () => {
    test('Se envia lista y se encuentra test por ID del contacto', async () => {
      usuarioService.getUsuarios = () => Promise.resolve(mockUsuario)
      usuarioService.getUsuariosSinLogueado = () => Promise.resolve(mockUsuario)
      const { getByTestId } = render(<Contactos setTituloComponent={ () => {} }/>)

      await waitFor(() => {
      expect(getByTestId('contacto_240')).toBeInTheDocument()
      expect(getByTestId('contacto_420')).toBeInTheDocument()
        })
    })  

    test('Se envia una lista vacia y se comprueba que no matchea ID.', async () => {
        usuarioService.getUsuarios = () => Promise.resolve(mockUsuarioVacio)
        usuarioService.getUsuariosSinLogueado = () => Promise.resolve(mockUsuarioVacio)
        const { queryByTestId } = render(<Contactos setTituloComponent={ () => {} }/>)
  
        await waitFor(() => {
        expect(queryByTestId('contacto_240')).toBeNull()
          })
      })  

      test('Se cliquea sobre un contacto y se verifica el path.', async () => {
        usuarioService.getUsuarios = () => Promise.resolve(mockUsuario)
        usuarioService.getUsuariosSinLogueado = () => Promise.resolve(mockUsuario)
        const pushSpy = jest.fn()
        const { getByTestId } = render(<BrowserRouter history={ {push: pushSpy} }><Contactos setTituloComponent={ () => {} }/> </BrowserRouter>)

        await waitFor(() => {
           // userEvent.click(getByTestId('contacto_240'))  
            fireEvent.click(getByTestId('contacto_240'))
            expect(pushSpy).toBeCalledWith(`/mensaje/-1/240`)
          })
        })

        test('Se cliquea sobre un contacto y se verifica el path DOS.', async () => {
          usuarioService.getUsuarios = () => Promise.resolve(mockUsuario)
          usuarioService.getUsuariosSinLogueado = () => Promise.resolve(mockUsuario)
          const history = createMemoryHistory()
          const { getByTestId } = render(<BrowserRouter history={ history }><Contactos setTituloComponent={ () => {} }/> </BrowserRouter>)
  
          await waitFor(() => {
              fireEvent.click(getByTestId('contacto_240'))
              expect(screen.getByText(/contactos/i)).toBeInTheDocument()
            })
          })
         
       

  })
})